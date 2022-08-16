module Shield::Api::OauthAuthorizations::Index
  # References:
  #
  # - https://luckyframework.org/guides/database/pagination
  macro included
    skip :require_logged_out

    # param page : Int32 = 1

    # get "/oauth/authorizations" do
    #   json OauthAuthorizationSerializer.new(
    #     oauth_authorizations: oauth_authorizations,
    #     pages: pages
    #   )
    # end

    def pages
      paginated_oauth_authorizations[0]
    end

    getter oauth_authorizations : Array(OauthAuthorization) do
      paginated_oauth_authorizations[1].results
    end

    private getter paginated_oauth_authorizations : Tuple(
      Lucky::Paginator,
      OauthAuthorizationQuery
    ) do
      paginate OauthAuthorizationQuery.new
        .is_active
        .preload_user
        .active_at.desc_order
    end
  end
end
