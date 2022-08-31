module Shield::Api::OauthAccessTokens::Index
  # References:
  #
  # - https://luckyframework.org/guides/database/pagination
  macro included
    skip :require_logged_out

    # param page : Int32 = 1

    # get "/oauth/tokens" do
    #   json BearerLoginSerializer.new(bearer_logins: bearer_logins, pages: pages)
    # end

    def pages
      paginated_bearer_logins[0]
    end

    getter bearer_logins : Array(BearerLogin) do
      paginated_bearer_logins[1].results
    end

    private getter paginated_bearer_logins : Tuple(
      Lucky::Paginator,
      BearerLoginQuery
    ) do
      paginate BearerLoginQuery.new
        .oauth_client_id.is_not_nil
        .is_active
        .active_at.desc_order
    end
  end
end
