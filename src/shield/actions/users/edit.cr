module Shield::Users::Edit
  macro included
    # get "/users/:user_id/edit" do
    #   authorize(:update, user) do
    #     html EditPage, user: user
    #   end
    # end

    def user
      UserQuery.find(user_id)
    end
  end
end
