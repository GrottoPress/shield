class EmailConfirmationCurrentUser::Show < BrowserAction
  include Shield::EmailConfirmationCurrentUser::Show

  skip :pin_login_to_ip_address

  get "/ec/profile" do
    html ShowPage, user: user
  end
end
