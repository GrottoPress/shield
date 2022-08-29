module Shield::Users::OauthGrants::Index
  # References:
  #
  # - https://luckyframework.org/guides/database/pagination
  macro included
    skip :require_logged_out

    # param page : Int32 = 1

    # get "/users/:user_id/oauth/grants" do
    #   html IndexPage, oauth_grants: oauth_grants, user: user, pages: pages
    # end

    getter user : User do
      UserQuery.find(user_id)
    end

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
        .user_id(user_id)
        .is_active
        .active_at.desc_order
    end
  end
end
