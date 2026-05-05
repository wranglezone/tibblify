#' Parse an OpenAPI spec
#'
#' @description
#' `r lifecycle::badge("experimental")`
#' Use `parse_openapi_spec()` to parse an
#' [OpenAPI spec](https://spec.openapis.org/oas/latest.html) or use
#' `parse_openapi_schema()` to parse an OpenAPI schema.
#'
#' @inheritParams .shared-params
#'
#' @return For `parse_openapi_spec()`, a nested data frame with the columns
#'
#'   * `endpoint` (`character`) Name of the endpoint.
#'   * `operations` (`list`) A list of data frames describing that endpoint.
#'   See the [Paths Object in the OpenAPI
#'   spec](https://spec.openapis.org/oas/latest.html#paths-object) for details.
#'   All references (`$ref`) in the spec are resolved.
#'
#'   For `parse_openapi_schema()`, a tibblify spec.
#' @export
#'
#' @examples
#' file <- '{
#'   "$schema": "http://json-schema.org/draft-04/schema",
#'   "title": "Starship",
#'   "description": "A vehicle.",
#'   "type": "object",
#'   "properties": {
#'     "name": {
#'       "type": "string",
#'       "description": "The name of this vehicle. The common name, e.g. Sand Crawler."
#'     },
#'     "model": {
#'       "type": "string",
#'       "description": "The model or official name of this vehicle."
#'     },
#'     "url": {
#'       "type": "string",
#'       "format": "uri",
#'       "description": "The hypermedia URL of this resource."
#'     },
#'     "edited": {
#'       "type": "string",
#'       "format": "date-time",
#'       "description": "the ISO 8601 date format of the time this resource was edited."
#'     }
#'   },
#'   "required": [
#'     "name",
#'     "model",
#'     "edited"
#'   ]
#' }'
#' parse_openapi_schema(file)
#'
#' # Spec example from https://swagger.io/docs/specification/v3_0/basic-structure/
#' spec_path <- system.file(
#'   "examples", "openapi", "sample_api.yaml", package = "tibblify"
#' )
#' spec <- parse_openapi_spec(spec_path)
#' spec
parse_openapi_spec <- function(file) {
  # https://spec.openapis.org/oas/v3.1.0#openapi-object2
  openapi_spec <- .read_spec(file)

  version <- openapi_spec$openapi
  if (is.null(version) || version < "3") {
    cli::cli_abort("OpenAPI versions before 3 are not supported.")
  }
  # cannot use `openapi_spec` for memoising, as hashing it takes much more time
  # than everything else. To still make sure the result is correct simply forget
  # previous results.
  if (rlang::is_installed("memoise")) {
    memoise::forget(.parse_schema_memoised)
  }

  out <- purrr::map(
    openapi_spec$paths,
    \(x) {
      .parse_path_item_object(path_item_object = x, openapi_spec = openapi_spec)
    }
  )

  .fast_tibble(
    list(
      endpoint = names2(out),
      operations = unname(out)
    )
  )
}

#' @export
#' @rdname parse_openapi_spec
parse_openapi_schema <- function(file) {
  rlang::check_installed("memoise")
  openapi_spec <- .read_spec(file)
  out <- .parse_schema(openapi_spec, "a", openapi_spec)
  memoise::forget(.parse_schema_memoised)

  if (out$type == "row") {
    tspec_row(!!!out$fields)
  } else {
    tspec_df(!!!out$fields)
  }
}

#' Read an OpenAPI spec from a file, connection, or list
#'
#' @inheritParams .shared-params
#' @returns (`list`) The parsed spec.
#' @keywords internal
.read_spec <- function(file, arg = caller_arg(file), call = caller_env()) {
  if (is_list(file)) {
    return(file)
  }

  rlang::check_installed("yaml")
  if (inherits(file, "connection")) {
    return(yaml::read_yaml(file)) # nocov
  }

  if (is_character(file)) {
    rlang::check_string(file)

    if (grepl("\n", file)) {
      out <- yaml::yaml.load(file)
    } else {
      out <- yaml::read_yaml(file, readLines.warn = FALSE)
    }

    return(out)
  }

  stop_input_type(
    file,
    c("a string", "a connection", "a list")
  )
}

#' Parse a path item object from an OpenAPI spec
#'
#' @inheritParams .shared-params-openapi
#' @returns A tibble of parsed operations with a `global_parameters` column.
#' @keywords internal
.parse_path_item_object <- function(path_item_object, openapi_spec) {
  # https://spec.openapis.org/oas/v3.1.0#path-item-object
  path_item_object <- .openapi_resolve_reference(path_item_object, openapi_spec)

  # FIXME pass along `parameters`?
  parameters <- .parse_parameters(path_item_object$parameters, openapi_spec)

  # TODO `summary`: An optional, string summary, intended to apply to all
  # operations in this path.
  #
  # TODO `description`: An optional, string description, intended to apply to
  # all operations in this path. CommonMark syntax MAY be used for rich text
  # representation.
  #
  # TODO `parameters`: A list of parameters that are applicable for all the
  # operations described under this path. These parameters can be overridden at
  # the operation level, but cannot be removed there. The list MUST NOT include
  # duplicated parameters. A unique parameter is defined by a combination of a
  # name and location. The list can use the Reference Object to link to
  # parameters that are defined at the OpenAPI Object's components/parameters.
  #
  # if (has_name(path_item_object, "summary") ||
  #     has_name(path_item_object, "description")) {
  #   browser()
  # }

  ops <- c("get", "put", "post", "delete", "options", "head", "patch", "trace")
  operations <- path_item_object[intersect(names(path_item_object), ops)]
  parsed_operations <- purrr::map(
    operations,
    \(x) .parse_operation_object(x, openapi_spec)
  )
  out <- vctrs::vec_rbind(!!!parsed_operations, .names_to = "operation")
  if (nrow(out) > 0) {
    out$global_parameters <- list(parameters)
  } else {
    out$global_parameters <- list()
  }
  out
}

#' Parse an operation object from an OpenAPI spec
#'
#' @inheritParams .shared-params-openapi
#' @returns A one-row tibble describing the operation.
#' @keywords internal
.parse_operation_object <- function(operation_object, openapi_spec) {
  # https://spec.openapis.org/oas/v3.1.0#operation-object
  operation_object <- .openapi_resolve_reference(operation_object, openapi_spec)

  spec <- tspec_object(
    tib_chr("summary", .required = FALSE),
    tib_chr("description", .required = FALSE),
    operation_id = tib_chr("operationId", .required = FALSE),
    tib_chr_vec("tags", .required = FALSE),
    tib_variant("parameters", .required = FALSE),
    request_body = tib_variant("requestBody", .required = FALSE),
    tib_variant("responses", .required = FALSE),
    tib_lgl("deprecated", .required = FALSE, .fill = FALSE),
    tib_variant("security", .required = FALSE),
  )
  operation_object$tags <- as.character(unlist(operation_object$tags))
  data <- tibblify(operation_object, spec)

  data$request_body <- list(.parse_request_body(
    data$request_body,
    openapi_spec
  ))
  data$parameters <- list(.parse_parameters(data$parameters, openapi_spec))
  data$responses <- list(.parse_responses_object(data$responses, openapi_spec))
  data$tags <- list(data$tags)
  data$security <- list(data$security)

  .fast_tibble(unclass(data), n = 1L)
}

#' Parse a request body object from an OpenAPI spec
#'
#' @inheritParams .shared-params-openapi
#' @returns (`tspec_row` or `NULL`) A parsed request body row spec, or `NULL`
#'   if `request_body` is `NULL`.
#' @keywords internal
.parse_request_body <- function(request_body, openapi_spec) {
  # https://spec.openapis.org/oas/v3.1.0#requestBodyObject
  if (is.null(request_body)) {
    return(NULL)
  }

  request_body <- .openapi_resolve_reference(request_body, openapi_spec)

  # TODO add extensions?
  spec <- tspec_row(
    tib_chr("description", .required = FALSE),
    tib_variant("content"),
    tib_lgl("required", .required = FALSE, .fill = FALSE)
  )
  parsed_request_body <- tibblify(request_body, spec)
  parsed_request_body$content[[1]] <- .parse_media_type_objects(
    parsed_request_body$content[[1]],
    openapi_spec
  )

  parsed_request_body
}

#' Parse a list of parameter objects from an OpenAPI spec
#'
#' @inheritParams .shared-params-openapi
#' @returns (`tbl_df` or `NULL`) A tibble of parsed parameters, or `NULL` if
#'   `parameters` is `NULL`.
#' @keywords internal
.parse_parameters <- function(parameters, openapi_spec) {
  # https://spec.openapis.org/oas/v3.1.0#parameter-object
  if (is.null(parameters)) {
    return(NULL)
  }

  parameters <- purrr::map(
    parameters,
    \(x) .openapi_resolve_reference(x, openapi_spec)
  )

  spec <- tspec_df(
    tib_chr("in"),
    tib_chr("name"),
    tib_chr("description", .required = FALSE),
    tib_lgl("required", .required = FALSE, .fill = FALSE),
    tib_lgl("deprecated", .required = FALSE, .fill = FALSE),
    tib_lgl("allowEmptyValue", .required = FALSE, .fill = FALSE),
    # TODO can use `.parse_schema()`?
    tib_row(
      "schema",
      tib_chr("type", .required = FALSE),
      tib_chr("description", .required = FALSE),
      # FIXME `enum` and `format` should go into a details column
      tib_variant("enum", .required = FALSE),
      tib_chr("format", .required = FALSE),
      .required = FALSE
    ),
    # FIXME `explode` and `style` should go into a details column
    tib_lgl("explode", .required = FALSE, .fill = FALSE),
    tib_chr("style", .required = FALSE),
  )

  tibblify(parameters, spec)
}

#' Parse a responses object from an OpenAPI spec
#'
#' @inheritParams .shared-params-openapi
#' @returns (`tbl_df`) A tibble of parsed response objects with a `status_code`
#'   column.
#' @keywords internal
.parse_responses_object <- function(responses_object, openapi_spec) {
  # https://spec.openapis.org/oas/v3.1.0#responsesObject
  responses_object <- purrr::map(
    responses_object,
    \(x) .openapi_resolve_reference(x, openapi_spec)
  )
  out <- purrr::map(responses_object, \(x) {
    .parse_response_object(x, openapi_spec)
  })
  vctrs::vec_rbind(!!!out, .names_to = "status_code")
}

#' Parse a single response object from an OpenAPI spec
#'
#' @inheritParams .shared-params-openapi
#' @returns (`tbl_df`) A one-row tibble describing the response.
#' @keywords internal
.parse_response_object <- function(response_object, openapi_spec) {
  spec <- tspec_object(
    tib_chr("description", .required = FALSE),
    tib_variant("headers", .required = FALSE),
    tib_variant("content", .required = FALSE),
    tib_variant("links", .required = FALSE),
  )
  parsed_response <- tibblify(response_object, spec)

  if (!rlang::is_empty(parsed_response$headers)) {
    parsed_response$headers <- .parse_header_objects(
      parsed_response$headers,
      openapi_spec
    )
  }
  # FIXME links
  if (!rlang::is_empty(parsed_response$links)) {
    cli::cli_abort(
      "We do not yet support {.field links} in OpenAPI response objects."
    )
  }
  parsed_response$content <- .parse_media_type_objects(
    parsed_response$content,
    openapi_spec
  )

  parsed_response$headers <- list(parsed_response$headers)
  parsed_response$content <- list(parsed_response$content)
  parsed_response$links <- list(parsed_response$links)

  .fast_tibble(parsed_response, n = 1L)
}

#' Parse a named list of media type objects from an OpenAPI spec
#'
#' @inheritParams .shared-params-openapi
#' @returns (`tbl_df`) A tibble with `media_type` and `spec` columns.
#' @keywords internal
.parse_media_type_objects <- function(media_type_objects, openapi_spec) {
  out <- purrr::map(
    media_type_objects,
    \(x) .parse_media_type_object(x, openapi_spec)
  )
  .fast_tibble(
    list(media_type = names2(out), spec = unname(out)),
    n = length(out)
  )
}

#' Parse a single media type object from an OpenAPI spec
#'
#' @inheritParams .shared-params-openapi
#' @returns A tibblify spec derived from the media type object's schema.
#' @keywords internal
.parse_media_type_object <- function(media_type_object, openapi_spec) {
  .schema_to_tspec(media_type_object$schema, openapi_spec)
}

#' Parse a named list of header objects from an OpenAPI spec
#'
#' @inheritParams .shared-params-openapi
#' @returns (`tbl_df`) A tibble of parsed header objects.
#' @keywords internal
.parse_header_objects <- function(header_objects, openapi_spec) {
  # https://spec.openapis.org/oas/v3.1.0#headerObject
  # The Header Object follows the structure of the Parameter Object with the following changes:
  # * `name` MUST NOT be specified, it is given in the corresponding headers map.
  # * `in` MUST NOT be specified, it is implicitly in header.
  # * All traits that are affected by the location MUST be applicable to a location of header (for example, style).
  header_objects <- purrr::map(
    header_objects,
    \(x) .openapi_resolve_reference(x, openapi_spec)
  )

  spec <- tspec_df(
    .names_to = "name",
    tib_chr("description", .required = FALSE),
    tib_lgl("required", .required = FALSE, .fill = FALSE),
    tib_lgl("deprecated", .required = FALSE, .fill = FALSE),
    tib_lgl("allowEmptyValue", .required = FALSE, .fill = FALSE),
    # TODO can use `.parse_schema()`?
    tib_row(
      "schema",
      tib_chr("type", .required = FALSE),
      tib_chr("description", .required = FALSE),
      # FIXME `enum` and `format` should go into a details column
      tib_chr_vec("enum", .required = FALSE),
      tib_chr("format", .required = FALSE),
      .required = FALSE
    ),
    # FIXME `explode` and `style` should go into a details column
    tib_lgl("explode", .required = FALSE, .fill = FALSE),
    tib_chr("style", .required = FALSE),
  )

  tibblify(header_objects, spec)
}

#' Convert an OpenAPI schema to a tibblify tspec
#'
#' @inheritParams .shared-params-openapi
#' @returns A tibblify spec (`tspec_row`, `tspec_df`, or a tib field).
#' @keywords internal
.schema_to_tspec <- function(schema, openapi_spec) {
  schema <- .openapi_resolve_reference(schema, openapi_spec)

  if (!is.null(schema$oneOf)) {
    out <- .handle_one_of_tspec(schema, openapi_spec)
    return(out)
  }
  if (!is.null(schema$allOf)) {
    out <- .handle_all_of_tspec(schema, openapi_spec)
    return(out)
  }

  type <- .get_openapi_type(schema)
  if (type == "object") {
    fields <- purrr::imap(
      schema$properties,
      \(x, y) .parse_schema_memoised(x, y, openapi_spec)
    )
    fields <- .apply_required(fields, schema$required)

    tspec_row(!!!fields)
  } else if (type == "array") {
    schema <- .openapi_resolve_reference(schema$items, openapi_spec)

    fields <- purrr::imap(
      schema$properties,
      \(x, y) .parse_schema_memoised(x, y, openapi_spec)
    )
    fields <- .apply_required(fields, schema$required)

    tspec_df(!!!fields)
  } else {
    # this is a bit of a hack...
    out <- .parse_schema(schema, "dummy", openapi_spec)
    out$required <- TRUE

    out
  }
}

#' Apply required flags to a list of tib fields
#'
#' @param fields (`list`) A named list of tib field specs.
#' @param required (`character`) Names of required fields.
#' @returns (`list`) The same `fields` list with `required = TRUE` set on the
#'   named fields.
#' @keywords internal
.apply_required <- function(fields, required) {
  for (field_name in intersect(required, names(fields))) {
    fields[[field_name]]$required <- TRUE
  }

  fields
}

#' Check whether any nested list element has a `$ref` key
#'
#' Short-circuiting check that avoids the expensive
#' `names(unlist(schema))` materialisation.
#'
#' @param x (`any`) The object to check.
#' @returns (`logical(1)`) `TRUE` if any element has a `$ref` key.
#' @keywords internal
.schema_has_ref <- function(x) {
  if (!is.list(x)) {
    return(FALSE)
  }
  if ("$ref" %in% names(x)) {
    return(TRUE)
  }
  any(vapply(x, .schema_has_ref, logical(1L)))
}

#' Resolve `$ref` references in an OpenAPI schema object
#'
#' @inheritParams .shared-params-openapi
#' @returns (`list`) The schema with all `$ref` references resolved.
#' @keywords internal
.openapi_resolve_reference <- function(schema, openapi_spec) {
  if (!is.list(schema)) {
    return(schema)
  }
  if (length(schema$allOf)) {
    schema$allOf <- purrr::compact(schema$allOf)
  }
  if (length(schema$anyOf)) {
    schema$anyOf <- purrr::compact(schema$anyOf)
  }

  ref <- schema$`$ref`
  # FIXME: This may still be too hacky.
  if (is.null(ref) && length(schema$allOf[[1]]$`$ref`)) {
    ref <- schema$allOf[[1]]$`$ref`
    schema$allOf[[1]]$`$ref` <- NULL
  }
  if (!is.null(ref)) {
    if (.is_url_string(ref)) {
      other_parts <- schema[setdiff(names(schema), "$ref")]
      return(c(yaml::read_yaml(ref, readLines.warn = FALSE), other_parts))
    }
    ref_parts <- strsplit(ref, "/")[[1]]
    ref_parts <- gsub("~1", "/", ref_parts)
    ref_parts <- utils::URLdecode(ref_parts)
    if (ref_parts[[1]] != "#") {
      cli::cli_abort(
        "{.field ref} does not start with {.value #}",
        .internal = TRUE
      )
    }
    # If any parts of the path are pure numbers (other than status codes), we
    # need to explicitly make them pure numbers.
    x_int <- suppressWarnings(as.integer(ref_parts))
    # Numeric ref_parts are 0-indexed list indices; convert to 1-indexed integers.
    is_idx <- !is.na(x_int) & x_int < 100L & (x_int == ref_parts)
    ref_parts <- as.list(ref_parts)
    ref_parts[is_idx] <- as.list(x_int[is_idx] + 1L)

    schema <- purrr::chuck(openapi_spec, !!!ref_parts[-1])

    if (is.null(schema)) {
      cli::cli_abort("No schema found for reference {.value {ref}}")
    }
    schema <- .openapi_resolve_reference(schema, openapi_spec)
  }

  # If anything under here has a $ref, keep going.
  if (.schema_has_ref(schema)) {
    schema <- purrr::map(schema, \(x) {
      .openapi_resolve_reference(x, openapi_spec)
    })
  }

  schema
}

#' Determine the type of an OpenAPI schema object
#'
#' @inheritParams .shared-params-openapi
#' @returns (`character(1)`) The type string, one of `"object"`, `"array"`,
#'   `"string"`, `"integer"`, `"boolean"`, `"number"`, or `"variant"`.
#' @keywords internal
.get_openapi_type <- function(schema) {
  type <- schema$type
  if (is.null(type)) {
    if (!is.null(schema$properties)) {
      type <- "object"
    } else if (!is.null(schema$items)) {
      type <- "array"
    }
  }

  rlang::check_string(type, allow_null = TRUE)
  type %||% "variant"
}

#' Parse an OpenAPI schema object into a tib field spec
#'
#' @inheritParams .shared-params
#' @inheritParams .shared-params-openapi
#' @returns A tib field spec corresponding to the schema type.
#' @keywords internal
.parse_schema <- function(schema, name, openapi_spec) {
  schema <- .openapi_resolve_reference(schema, openapi_spec)
  if (!is.null(schema$oneOf)) {
    out <- .handle_one_of(schema, name, openapi_spec)
    return(out)
  }
  # Since we're just combining specs, this should be enough.
  if (!is.null(schema$anyOf)) {
    schema$oneOf <- schema$anyOf
    schema$anyOf <- NULL
    out <- .handle_one_of(schema, name, openapi_spec)
    return(out)
  }
  if (!is.null(schema$allOf)) {
    out <- .handle_all_of(schema, name, openapi_spec)
    return(out)
  }

  type <- .get_openapi_type(schema)

  # TODO description, example
  # TODO format?!

  if (rlang::is_empty(type)) {} else if (type == "object") {
    if (!is.null(schema$additionalProperties)) {
      # FIXME hack required for asana which somehow has `additionalProperties = TRUE`
      # openapi_spec$components$schemas$RuleTriggerRequest$properties$action_data$additionalProperties
      if (is.list(schema$additionalProperties)) {
        additional_properties <- .openapi_resolve_reference(
          schema$additionalProperties,
          openapi_spec
        )
      } else {
        additional_properties <- NULL
      }
    } else {
      additional_properties <- NULL
    }

    fields <- purrr::imap(
      c(schema$properties, additional_properties$properties),
      \(x, y) .parse_schema_memoised(x, y, openapi_spec)
    )
    fields <- .apply_required(
      fields,
      c(schema$required, additional_properties$required)
    )
    tib_row(name, !!!fields, .required = FALSE)

    # TODO additionalProperties?
  } else if (type == "string") {
    # TODO support for `enum` or `pattern`?
    tib_chr(name, .required = FALSE)
  } else if (type == "array") {
    items <- schema$items
    if (is.null(items)) {
      cli::cli_inform("Array has no items")
      field_spec <- tib_variant(name)
      return(field_spec)
    }

    inner_tib <- .parse_schema_memoised(schema$items, name, openapi_spec)
    if (inner_tib$type == "scalar") {
      tib_vector(name, inner_tib$ptype, .required = FALSE)
    } else if (inner_tib$type == "row") {
      tib_df(name, !!!inner_tib$fields, .required = FALSE)
    } else {
      inner_tib
    }
    # TODO support for `minItems`, `maxItems`?
  } else if (type == "integer") {
    tib_int(name, .required = FALSE)
  } else if (type == "boolean") {
    tib_lgl(name, .required = FALSE)
  } else if (type == "number") {
    tib_dbl(name, .required = FALSE)
  } else if (type == "variant") {
    tib_variant(name, .required = FALSE)
  } else {
    cli::cli_abort("Unsupported type")
  }
}

# Explanation for `allOf`, `oneOf`, and `anyOf`
# https://swagger.io/docs/specification/data-models/oneof-anyof-allof-not/

#' Handle an `allOf` schema by combining sub-schemas into a tib field
#'
#' @inheritParams .shared-params
#' @inheritParams .shared-params-openapi
#' @returns A combined tib field spec.
#' @keywords internal
.handle_all_of <- function(schema, name, openapi_spec) {
  # must satisfy all the schemas -> combine them
  out <- purrr::map(schema$allOf, \(x) .parse_schema(x, name, openapi_spec))
  # TODO fix `call`
  .tib_combine(out, name, current_call())
}

#' Handle an `allOf` schema by combining sub-schemas into a tspec
#'
#' @inheritParams .shared-params-openapi
#' @returns A combined tspec.
#' @keywords internal
.handle_all_of_tspec <- function(schema, openapi_spec) {
  # must satisfy all the schemas -> combine them
  out <- purrr::map(schema$allOf, \(x) .schema_to_tspec(x, openapi_spec))
  # We can have some hacky "dummy" variants in here right now. For now we'll
  # remove them.
  out <- purrr::discard(
    out,
    function(x) {
      x$type == "variant" && x$key == "dummy"
    }
  )
  tspec_combine(!!!out)
}

#' Handle a `oneOf` schema by combining sub-schemas into a tib field
#'
#' @inheritParams .shared-params
#' @inheritParams .shared-params-openapi
#' @returns A combined tib field spec, or `tib_variant()` if schemas are
#'   incompatible.
#' @keywords internal
.handle_one_of <- function(schema, name, openapi_spec) {
  out <- purrr::map(schema$oneOf, \(x) .parse_schema(x, name, openapi_spec))
  # must satisfy one of the schemas
  # for now simply try to combine them...
  tryCatch(
    {
      # TODO fix `call`
      .tib_combine(out, name, current_call())
    },
    error = function(cnd) {
      types <- purrr::map_chr(out, "type")
      if ("row" %in% types) {
        .tib_combine(out[types == "row"], name, current_call())
      } else {
        tib_variant(name, .required = FALSE)
      }
    }
  )
}

#' Handle a `oneOf` schema by combining sub-schemas into a tspec
#'
#' @inheritParams .shared-params-openapi
#' @returns A combined tspec, or `tib_variant("dummy")` if schemas are
#'   incompatible.
#' @keywords internal
.handle_one_of_tspec <- function(schema, openapi_spec) {
  out <- purrr::map(schema$oneOf, \(x) .schema_to_tspec(x, openapi_spec))
  # must satisfy one of the schemas
  # for now simply try to combine them...
  tryCatch(
    {
      tspec_combine(!!!out)
    },
    error = function(cnd) {
      tib_variant("dummy")
    }
  )
}

if (rlang::is_installed("memoise")) {
  .parse_schema_memoised <- memoise::memoise(
    .parse_schema,
    omit_args = "openapi_spec"
  )
} else {
  .parse_schema_memoised <- .parse_schema
}

#' Create a minimal tibble from a list
#'
#' @param x (`list`) A named list of equal-length vectors.
#' @param n (`integer(1)` or `NULL`) Number of rows; inferred from `x` if
#'   `NULL`.
#' @returns (`tbl_df`) A tibble constructed directly from `x`.
#' @keywords internal
.fast_tibble <- function(x, n = NULL) {
  vctrs::new_data_frame(x, n = n, class = c("tbl_df", "tbl"))
}
