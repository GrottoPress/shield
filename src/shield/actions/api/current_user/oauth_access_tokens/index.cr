module Shield::Api::CurrentUser::OauthAccessTokens::Index
  # References:
  #
  # - https://luckyframework.org/guides/database/pagination
  macro included
    skip :require_logged_out

    # param page : Int32 = 1

    # get "/account/oauth/tokens" do
    #   json BearerLoginSerializer.new(bearer_logins: bearer_logins, pages: pages)
    # end

    def user
      current_user_or_bearer
    end

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
        .user_id(user.id)
        .oauth_client_id.is_not_nil
        .is_active
        .active_at.desc_order
    end

    def authorize?(user : Shield::User) : Bool
      user.id == self.user.id
    end
  end
end
