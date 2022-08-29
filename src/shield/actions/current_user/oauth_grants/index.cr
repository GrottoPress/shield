module Shield::CurrentUser::OauthGrants::Index
  # References:
  #
  # - https://luckyframework.org/guides/database/pagination
  macro included
    skip :require_logged_out

    # param page : Int32 = 1

    # get "/account/oauth/grants" do
    #   html IndexPage, oauth_grants: oauth_grants, pages: pages
    # end

    def user
      current_user
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
        .user_id(user.id)
        .is_active
        .active_at.desc_order
    end

    def authorize?(user : Shield::User) : Bool
      user.id == self.user.id
    end
  end
end
