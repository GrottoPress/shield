module Shield::ShowUser
  macro included
    # get "/users/:user_id" do
    #   authorize(:read, user)
    #   html ShowPage, user: user
    # end

    private def user
      UserQuery.find(user_id)
    end
  end
end
