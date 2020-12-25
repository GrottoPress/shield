module Shield::Api::EmailConfirmationCurrentUser::Show
  macro included
    include Shield::Api::CurrentUser::Show

    # get "/account" do
    #   json({
    #     status: "success",
    #     data: {user: UserSerializer.new(user)}
    #   })
    # end
  end
end
