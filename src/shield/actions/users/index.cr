module Shield::Users::Index
  macro included
    skip :require_logged_out

    # get "/users" do
    #   html IndexPage, users: users
    # end

    @[Memoize]
    def users
      UserQuery.all.to_a
    end
  end
end
