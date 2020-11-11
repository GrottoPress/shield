module Shield::Api::Users::Index
  macro included
    skip :require_logged_out

    # param page : Int32 = 1

    # get "/users" do
    #   json({
    #     status: "success",
    #     data: {users: UserSerializer.for_collection(users)},
    #     pages: {
    #       first: pages.path_to_page(1),
    #       previous: pages.path_to_previous,
    #       current: pages.path_to_page(page),
    #       next: pages.path_to_next,
    #       last: pages.path_to_page(pages.total)
    #     }
    #   })
    # end

    def pages
      paginated_users[0]
    end

    @[Memoize]
    def users
      paginated_users[1].map &.itself
    end

    private def paginated_users
      paginate(UserQuery.new)
    end
  end
end
