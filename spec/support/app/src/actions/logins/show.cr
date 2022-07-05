class Logins::Show < BrowserAction
  include Shield::Logins::Show

  skip :check_authorization
  skip :pin_login_to_ip_address

  get "/logins/:login_id" do
    html ShowPage, login: login
  end
end
