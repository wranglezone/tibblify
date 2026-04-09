# can guess spec for citm_catalog

    Code
      guess_tspec_list(x, simplify_list = FALSE)
    Output
      tspec_object(
        tib_row(
          "areaNames",
          tib_chr("205705993"),
          tib_chr("205705994"),
          tib_chr("205705995"),
        ),
        tib_row(
          "audienceSubCategoryNames",
          tib_chr("337100890"),
        ),
        tib_unspecified("blockNames"),
        tib_df(
          "events",
          .names_to = ".names",
          tib_unspecified("description"),
          tib_int("id"),
          tib_chr("logo"),
          tib_chr("name"),
          tib_int_vec("subTopicIds"),
          tib_unspecified("subjectCode"),
          tib_unspecified("subtitle"),
          tib_int_vec("topicIds"),
        ),
        tib_df(
          "performances",
          tib_int("eventId"),
          tib_int("id"),
          tib_unspecified("logo"),
          tib_unspecified("name"),
          tib_df(
            "prices",
            tib_int("amount"),
            tib_int("audienceSubCategoryId"),
            tib_int("seatCategoryId"),
          ),
          tib_df(
            "seatCategories",
            tib_df(
              "areas",
              tib_int("areaId"),
              tib_unspecified("blockIds"),
            ),
            tib_int("seatCategoryId"),
          ),
          tib_unspecified("seatMapImage"),
          tib_dbl("start"),
          tib_chr("venueCode"),
        ),
        tib_row(
          "seatCategoryNames",
          tib_chr("338937235"),
          tib_chr("338937236"),
          tib_chr("338937238"),
        ),
        tib_row(
          "subTopicNames",
          tib_chr("337184262"),
          tib_chr("337184263"),
          tib_chr("337184267"),
        ),
        tib_unspecified("subjectNames"),
        tib_row(
          "topicNames",
          tib_chr("107888604"),
          tib_chr("324846098"),
          tib_chr("324846099"),
          tib_chr("324846100"),
        ),
        tib_row(
          "topicSubTopics",
          tib_int_vec("107888604"),
          tib_int("324846098"),
          tib_int_vec("324846099"),
          tib_int_vec("324846100"),
        ),
        tib_row(
          "venueNames",
          tib_chr("PLEYEL_PLEYEL"),
        ),
      )

# guess_tspec_list errors informatively for empty input

    Code
      (expect_error(guess_tspec_list(list())))
    Output
      <error/rlang_error>
      Error in `guess_tspec_list()`:
      ! `list()` must not be empty.

# guess_tspec_list errors informatively for bad objects

    Code
      (expect_error(guess_tspec_list(list(a = 1, 1))))
    Output
      <error/rlang_error>
      Error in `guess_tspec_list()`:
      ! `list(a = 1, 1)` is neither an object nor a list of objects.
      An object
      v is a list,
      x is fully named,
      v and has unique names.
      A list of objects is
      x a data frame or
      v a list and
      x each element is `NULL` or an object.
    Code
      (expect_error(guess_tspec_list(list(a = 1, a = 1))))
    Output
      <error/rlang_error>
      Error in `guess_tspec_list()`:
      ! `list(a = 1, a = 1)` is neither an object nor a list of objects.
      An object
      v is a list,
      v is fully named,
      x and has unique names.
      A list of objects is
      x a data frame or
      v a list and
      x each element is `NULL` or an object.

# guess_tspec_list can guess spec for discog

    Code
      print(guess_tspec_list(discog))
    Output
      tspec_df(
        tib_int("instance_id"),
        tib_chr("date_added"),
        tib_row(
          "basic_information",
          tib_df(
            "labels",
            tib_chr("name"),
            tib_chr("entity_type"),
            tib_chr("catno"),
            tib_chr("resource_url"),
            tib_int("id"),
            tib_chr("entity_type_name"),
          ),
          tib_int("year"),
          tib_chr("master_url"),
          tib_df(
            "artists",
            tib_chr("join"),
            tib_chr("name"),
            tib_chr("anv"),
            tib_chr("tracks"),
            tib_chr("role"),
            tib_chr("resource_url"),
            tib_int("id"),
          ),
          tib_int("id"),
          tib_chr("thumb"),
          tib_chr("title"),
          tib_df(
            "formats",
            tib_variant("descriptions", required = FALSE),
            tib_chr("text", required = FALSE),
            tib_chr("name"),
            tib_chr("qty"),
          ),
          tib_chr("cover_image"),
          tib_chr("resource_url"),
          tib_int("master_id"),
        ),
        tib_int("id"),
        tib_int("rating"),
      )

# guess_tspec_list can guess spec for gh_users

    Code
      print(guess_tspec_list(gh_users))
    Output
      tspec_df(
        tib_chr("login"),
        tib_int("id"),
        tib_chr("avatar_url"),
        tib_chr("gravatar_id"),
        tib_chr("url"),
        tib_chr("html_url"),
        tib_chr("followers_url"),
        tib_chr("following_url"),
        tib_chr("gists_url"),
        tib_chr("starred_url"),
        tib_chr("subscriptions_url"),
        tib_chr("organizations_url"),
        tib_chr("repos_url"),
        tib_chr("events_url"),
        tib_chr("received_events_url"),
        tib_chr("type"),
        tib_lgl("site_admin"),
        tib_chr("name"),
        tib_chr("company"),
        tib_chr("blog"),
        tib_chr("location"),
        tib_chr("email"),
        tib_lgl("hireable"),
        tib_chr("bio"),
        tib_int("public_repos"),
        tib_int("public_gists"),
        tib_int("followers"),
        tib_int("following"),
        tib_chr("created_at"),
        tib_chr("updated_at"),
      )

# guess_tspec_list respects empty_list_unspecified (#83)

    Code
      spec
    Output
      tspec_df(
        tib_chr("url"),
        tib_int("id"),
        tib_chr("name"),
        tib_chr("gender"),
        tib_chr("culture"),
        tib_chr("born"),
        tib_chr("died"),
        tib_lgl("alive"),
        tib_chr_vec("titles"),
        tib_variant("aliases"),
        tib_chr("father"),
        tib_chr("mother"),
        tib_chr("spouse"),
        tib_variant("allegiances"),
        tib_variant("books"),
        tib_chr_vec("povBooks"),
        tib_chr_vec("tvSeries"),
        tib_chr_vec("playedBy"),
      )

# guess_tspec_list can guess spec for gsoc-2018

    Code
      guess_tspec_list(x)
    Output
      tspec_df(
        .names_to = ".names",
        tib_chr("@context"),
        tib_chr("@type"),
        tib_chr("name"),
        tib_chr("description"),
        tib_row(
          "sponsor",
          tib_chr("@type"),
          tib_chr("name"),
          tib_chr("disambiguatingDescription"),
          tib_chr("description"),
          tib_chr("url"),
          tib_chr("logo"),
        ),
        tib_row(
          "author",
          tib_chr("@type"),
          tib_chr("name"),
        ),
      )

