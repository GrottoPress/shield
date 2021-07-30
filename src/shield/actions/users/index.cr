module Shield::Users::Index
  macro included
    skip :require_logged_out

    # param page : Int32 = 1

    # get "/users" do
    #   html IndexPage, users: users, pages: pages
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
