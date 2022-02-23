module Shield::Api::CurrentUser::BearerLogins::Index
  # References:
  #
  # - https://luckyframework.org/guides/database/pagination
  macro included
    skip :require_logged_out

    # param page : Int32 = 1

    # get "/account/bearer-logins" do
    #   json({
    #     status: "success",
    #     data: {
    #       bearer_logins: BearerLoginSerializer.for_collection(bearer_logins)
    #     },
    #     pages: {
    #       current: page,
    #       total: pages.total
    #     }
    #   })
    # end

    def pages
      paginated_bearer_logins[0]
    end

    getter bearer_logins : Array(BearerLogin) do
      paginated_bearer_logins[1].results
    end

    getter paginated_bearer_logins : Tuple(
      Lucky::Paginator,
      BearerLoginQuery
    ) do
      paginate BearerLoginQuery.new
        .user_id(user.id)
        .is_active
        .active_at.desc_order
    end

    def user
      current_user_or_bearer
    end

    def authorize?(user : Shield::User) : Bool
      user.id == self.user.id
    end
  end
end
