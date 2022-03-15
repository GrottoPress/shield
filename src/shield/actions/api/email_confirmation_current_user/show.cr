module Shield::Api::EmailConfirmationCurrentUser::Show
  macro included
    include Shield::Api::CurrentUser::Show

    # get "/account" do
    #   json UserSerializer.new(user: user)
    # end
  end
end
