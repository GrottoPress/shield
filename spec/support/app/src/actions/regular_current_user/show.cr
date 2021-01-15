class RegularCurrentUser::Show < BrowserAction
  include Shield::CurrentUser::Show

  skip :pin_login_to_ip_address

  get "/profile" do
    html ShowPage, user: user
  end
end
