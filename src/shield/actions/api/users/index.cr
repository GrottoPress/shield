module Shield::Api::Users::Index
  macro included
    skip :require_logged_out

    # param page : Int32 = 1

    # get "/users" do
    #   json({
    #     status: "success",
    #     data: {users: UserSerializer.for_collection(users)},
    #     pages: {
    #       current: page,
    #       total: pages.total
    #     }
    #   })
    # end

    def pages
      paginated_users[0]
    end

    @[Memoize]
    def users : Array(User)
      paginated_users[1].results
    end

    @[Memoize]
    private def paginated_users : Tuple(Lucky::Paginator, UserQuery)
      paginate(UserQuery.new)
    end
  end
end
