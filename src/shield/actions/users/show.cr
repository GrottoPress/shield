module Shield::Users::Show
  macro included
    # get "/users/:user_id" do
    #   authorize(:read, user) do
    #     html ShowPage, user: user
    #   end
    # end

    def user
      UserQuery.find(user_id)
    end
  end
end
