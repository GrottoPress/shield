module Shield::Api::Users::Index
  macro included
    skip :require_logged_out

    # param page : Int32 = 1

    # get "/users" do
    #   json({
    #     status: "success",
    #     data: {users: UserSerializer.for_collection(users)},
    #     pages: PaginationSerializer.new(pages)
    #   })
    # end

    def pages
      paginated_users[0]
    end

    getter users : Array(User) do
      paginated_users[1].results
    end

    private getter paginated_users : Tuple(Lucky::Paginator, UserQuery) do
      paginate(UserQuery.new)
    end
  end
end
