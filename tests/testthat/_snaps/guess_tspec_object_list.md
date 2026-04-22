# guess_tspec_object_list can guess spec for discog

    Code
      guess_tspec_object_list(discog)
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

# guess_tspec_object_list can guess spec for gh_users

    Code
      guess_tspec_object_list(gh_users)
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

# guess_tspec_object_list can guess spec for gsoc-2018

    Code
      guess_tspec_object_list(read_sample_json("gsoc-2018.json"))
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

