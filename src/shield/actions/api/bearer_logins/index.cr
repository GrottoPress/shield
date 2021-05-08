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

    @[Memoize]
    def bearer_logins : Array(BearerLogin)
      paginated_bearer_logins[1].results
    end

    @[Memoize]
    private def paginated_bearer_logins : Tuple(
      Lucky::Paginator,
      BearerLoginQuery
    )
      paginate BearerLoginQuery.new.user_id(user.id).is_active
    end

    def user
      current_or_bearer_user!
    end

    def authorize?(user : User) : Bool
      user.id == self.user.id
    end
  end
end
