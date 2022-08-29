module Shield::Api::OauthGrants::Index
  # References:
  #
  # - https://luckyframework.org/guides/database/pagination
  macro included
    skip :require_logged_out

    # param page : Int32 = 1

    # get "/oauth/grants" do
    #   json OauthGrantSerializer.new(oauth_grants: oauth_grants, pages: pages)
    # end

    def pages
      paginated_oauth_grants[0]
    end

    getter oauth_grants : Array(OauthGrant) do
      paginated_oauth_grants[1].results
    end

    private getter paginated_oauth_grants : Tuple(
      Lucky::Paginator,
      OauthGrantQuery
    ) do
      paginate OauthGrantQuery.new
        .is_active
        .preload_user
        .active_at.desc_order
    end
  end
end
