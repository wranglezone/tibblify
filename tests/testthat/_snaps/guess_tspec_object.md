# guess_tspec_object gives nice errors

    Code
      (expect_error(guess_tspec_object(tibble(a = 1))))
    Output
      <error/rlang_error>
      Error in `guess_tspec_object()`:
      ! `x` must not be a dataframe.
      i Did you want to use `guess_tspec_df()` instead?
    Code
      (expect_error(guess_tspec_object(1:3)))
    Output
      <error/rlang_error>
      Error in `guess_tspec_object()`:
      ! `x` must be a list, not an integer vector.

---

    Code
      (expect_error(guess_tspec_object(list(1, a = 1))))
    Output
      <error/rlang_error>
      Error in `guess_tspec_object()`:
      ! `x` must be fully named.
    Code
      (expect_error(guess_tspec_object(list(a = 1, a = 1))))
    Output
      <error/rlang_error>
      Error in `guess_tspec_object()`:
      ! Names of `x` must be unique.

# guess_tspec_object informs about unspecified elements

    Code
      guess_tspec_object(x, inform_unspecified = TRUE)
    Message
      The spec contains 9 unspecified fields:
      * blockNames
      * events->description
      * events->subjectCode
      * events->subtitle
      * performances->logo
      * performances->name
      * performances->seatCategories->areas->blockIds
      * performances->seatMapImage
      * subjectNames
    Output
      object omitted

# guess_tspec_object can guess spec for citm_catalog

    Code
      guess_tspec_object(x, simplify_list = FALSE)
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

# guess_tspec_object can guess spec for twitter

    Code
      guess_tspec_object(read_sample_json("twitter.json"))
    Output
      tspec_object(
        tib_df(
          "statuses",
          tib_row(
            "metadata",
            tib_chr("result_type"),
            tib_chr("iso_language_code"),
          ),
          tib_chr("created_at"),
          tib_dbl("id"),
          tib_chr("id_str"),
          tib_chr("text"),
          tib_chr("source"),
          tib_lgl("truncated"),
          tib_dbl("in_reply_to_status_id"),
          tib_chr("in_reply_to_status_id_str"),
          tib_int("in_reply_to_user_id"),
          tib_chr("in_reply_to_user_id_str"),
          tib_chr("in_reply_to_screen_name"),
          tib_row(
            "user",
            tib_dbl("id"),
            tib_chr("id_str"),
            tib_chr("name"),
            tib_chr("screen_name"),
            tib_chr("location"),
            tib_chr("description"),
            tib_chr("url"),
            tib_df(
              "entities",
              .names_to = ".names",
              tib_df(
                "urls",
                tib_chr("url"),
                tib_chr("expanded_url"),
                tib_chr("display_url"),
                tib_int_vec("indices"),
              ),
            ),
            tib_lgl("protected"),
            tib_int("followers_count"),
            tib_int("friends_count"),
            tib_int("listed_count"),
            tib_chr("created_at"),
            tib_int("favourites_count"),
            tib_int("utc_offset"),
            tib_chr("time_zone"),
            tib_lgl("geo_enabled"),
            tib_lgl("verified"),
            tib_int("statuses_count"),
            tib_chr("lang"),
            tib_lgl("contributors_enabled"),
            tib_lgl("is_translator"),
            tib_lgl("is_translation_enabled"),
            tib_chr("profile_background_color"),
            tib_chr("profile_background_image_url"),
            tib_chr("profile_background_image_url_https"),
            tib_lgl("profile_background_tile"),
            tib_chr("profile_image_url"),
            tib_chr("profile_image_url_https"),
            tib_chr("profile_banner_url", required = FALSE),
            tib_chr("profile_link_color"),
            tib_chr("profile_sidebar_border_color"),
            tib_chr("profile_sidebar_fill_color"),
            tib_chr("profile_text_color"),
            tib_lgl("profile_use_background_image"),
            tib_lgl("default_profile"),
            tib_lgl("default_profile_image"),
            tib_lgl("following"),
            tib_lgl("follow_request_sent"),
            tib_lgl("notifications"),
          ),
          tib_unspecified("geo"),
          tib_unspecified("coordinates"),
          tib_unspecified("place"),
          tib_unspecified("contributors"),
          tib_int("retweet_count"),
          tib_int("favorite_count"),
          tib_row(
            "entities",
            tib_df(
              "hashtags",
              tib_chr("text"),
              tib_int_vec("indices"),
            ),
            tib_unspecified("symbols"),
            tib_unspecified("urls"),
            tib_df(
              "user_mentions",
              tib_chr("screen_name"),
              tib_chr("name"),
              tib_int("id"),
              tib_chr("id_str"),
              tib_int_vec("indices"),
            ),
            tib_df(
              "media",
              .required = FALSE,
              tib_dbl("id"),
              tib_chr("id_str"),
              tib_int_vec("indices"),
              tib_chr("media_url"),
              tib_chr("media_url_https"),
              tib_chr("url"),
              tib_chr("display_url"),
              tib_chr("expanded_url"),
              tib_chr("type"),
              tib_df(
                "sizes",
                .names_to = ".names",
                tib_int("w"),
                tib_int("h"),
                tib_chr("resize"),
              ),
              tib_dbl("source_status_id"),
              tib_chr("source_status_id_str"),
            ),
          ),
          tib_lgl("favorited"),
          tib_lgl("retweeted"),
          tib_chr("lang"),
          tib_row(
            "retweeted_status",
            .required = FALSE,
            tib_row(
              "metadata",
              .required = FALSE,
              tib_chr("result_type"),
              tib_chr("iso_language_code"),
            ),
            tib_chr("created_at", required = FALSE),
            tib_dbl("id", required = FALSE),
            tib_chr("id_str", required = FALSE),
            tib_chr("text", required = FALSE),
            tib_chr("source", required = FALSE),
            tib_lgl("truncated", required = FALSE),
            tib_unspecified("in_reply_to_status_id", required = FALSE),
            tib_unspecified("in_reply_to_status_id_str", required = FALSE),
            tib_unspecified("in_reply_to_user_id", required = FALSE),
            tib_unspecified("in_reply_to_user_id_str", required = FALSE),
            tib_unspecified("in_reply_to_screen_name", required = FALSE),
            tib_row(
              "user",
              .required = FALSE,
              tib_int("id"),
              tib_chr("id_str"),
              tib_chr("name"),
              tib_chr("screen_name"),
              tib_chr("location"),
              tib_chr("description"),
              tib_unspecified("url"),
              tib_df(
                "entities",
                .names_to = ".names",
                tib_df(
                  "urls",
                  tib_chr("url"),
                  tib_chr("expanded_url"),
                  tib_chr("display_url"),
                  tib_int_vec("indices"),
                ),
              ),
              tib_lgl("protected"),
              tib_int("followers_count"),
              tib_int("friends_count"),
              tib_int("listed_count"),
              tib_chr("created_at"),
              tib_int("favourites_count"),
              tib_int("utc_offset"),
              tib_chr("time_zone"),
              tib_lgl("geo_enabled"),
              tib_lgl("verified"),
              tib_int("statuses_count"),
              tib_chr("lang"),
              tib_lgl("contributors_enabled"),
              tib_lgl("is_translator"),
              tib_lgl("is_translation_enabled"),
              tib_chr("profile_background_color"),
              tib_chr("profile_background_image_url"),
              tib_chr("profile_background_image_url_https"),
              tib_lgl("profile_background_tile"),
              tib_chr("profile_image_url"),
              tib_chr("profile_image_url_https"),
              tib_chr("profile_banner_url"),
              tib_chr("profile_link_color"),
              tib_chr("profile_sidebar_border_color"),
              tib_chr("profile_sidebar_fill_color"),
              tib_chr("profile_text_color"),
              tib_lgl("profile_use_background_image"),
              tib_lgl("default_profile"),
              tib_lgl("default_profile_image"),
              tib_lgl("following"),
              tib_lgl("follow_request_sent"),
              tib_lgl("notifications"),
            ),
            tib_unspecified("geo", required = FALSE),
            tib_unspecified("coordinates", required = FALSE),
            tib_unspecified("place", required = FALSE),
            tib_unspecified("contributors", required = FALSE),
            tib_int("retweet_count", required = FALSE),
            tib_int("favorite_count", required = FALSE),
            tib_row(
              "entities",
              .required = FALSE,
              tib_df(
                "hashtags",
                tib_chr("text"),
                tib_int_vec("indices"),
              ),
              tib_unspecified("symbols"),
              tib_unspecified("urls"),
              tib_unspecified("user_mentions"),
              tib_df(
                "media",
                .required = FALSE,
                tib_dbl("id"),
                tib_chr("id_str"),
                tib_int_vec("indices"),
                tib_chr("media_url"),
                tib_chr("media_url_https"),
                tib_chr("url"),
                tib_chr("display_url"),
                tib_chr("expanded_url"),
                tib_chr("type"),
                tib_df(
                  "sizes",
                  .names_to = ".names",
                  tib_int("w"),
                  tib_int("h"),
                  tib_chr("resize"),
                ),
              ),
            ),
            tib_lgl("favorited", required = FALSE),
            tib_lgl("retweeted", required = FALSE),
            tib_lgl("possibly_sensitive", required = FALSE),
            tib_chr("lang", required = FALSE),
          ),
          tib_lgl("possibly_sensitive", required = FALSE),
        ),
        tib_row(
          "search_metadata",
          tib_dbl("completed_in"),
          tib_dbl("max_id"),
          tib_chr("max_id_str"),
          tib_chr("next_results"),
          tib_chr("query"),
          tib_chr("refresh_url"),
          tib_int("count"),
          tib_int("since_id"),
          tib_chr("since_id_str"),
        ),
      )

