module Shield::EmailConfirmationCurrentUser::Show
  macro included
    include Shield::CurrentUser::Show

    # get "/account" do
    #   html ShowPage, user: user
    # end
  end
end
