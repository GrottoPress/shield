module Shield::Api::CurrentUser::OauthAuthorizations::Index
  macro included
    skip :require_logged_out

    # param page : Int32 = 1

    # get "/account/oauth/authorizations" do
    #   json OauthAuthorizationSerializer.new(
    #     oauth_authorizations: oauth_authorizations,
    #     pages: pages
    #   )
    # end

    def user
      current_user
    end

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
        .user_id(user.id)
        .is_active
        .active_at.desc_order
    end

    def authorize?(user : Shield::User) : Bool
      user.id == self.user.id
    end
  end
end
