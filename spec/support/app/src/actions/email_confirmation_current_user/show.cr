class EmailConfirmationCurrentUser::Show < BrowserAction
  include Shield::EmailConfirmationCurrentUser::Show

  get "/account" do
    plain_text "EmailConfirmationCurrentUser::Show"
  end
end
