module Shield::Api::Logins::Index
  macro included
    skip :require_logged_out

    # param page : Int32 = 1

    # get "/logins" do
    #   json({
    #     status: "success",
    #     data: {logins: LoginSerializer.for_collection(logins)},
    #     pages: {
    #       current: page,
    #       total: pages.total
    #     }
    #   })
    # end

    def pages
      paginated_logins[0]
    end

    @[Memoize]
    def logins : Array(Login)
      paginated_logins[1].results
    end

    @[Memoize]
    private def paginated_logins : Tuple(Lucky::Paginator, LoginQuery)
      paginate LoginQuery.new.user_id(user.id).is_active
    end

    def user
      current_or_bearer_user!
    end

    def authorize?(user : User) : Bool
      user.id == self.user.id
    end
  end
end
