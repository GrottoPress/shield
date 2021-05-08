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
