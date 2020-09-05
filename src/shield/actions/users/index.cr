module Shield::Users::Index
  macro included
    skip :require_logged_out

    # param page : Int32 = 1

    # get "/users" do
    #   pages, users = paginate(UserQuery.new)
    #   html IndexPage, users: users, pages: pages
    # end
  end
end
