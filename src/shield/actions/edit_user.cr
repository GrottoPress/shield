module Shield::EditUser
  macro included
    # get "/users/:user_id/edit" do
    #   authorize(:update, user)
    #   html EditPage, user: user
    # end

    private def user
      UserQuery.find(user_id)
    end
  end
end
