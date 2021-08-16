module Shield::Api::BearerLogins::Index
  macro included
    skip :require_logged_out

    # param page : Int32 = 1

    # get "/bearer-logins" do
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
      paginate BearerLoginQuery.new.user_id(user.id).is_active
    end

    def user
      current_or_bearer_user
    end

    def authorize?(user : Shield::User) : Bool
      user.id == self.user.id
    end
  end
end
