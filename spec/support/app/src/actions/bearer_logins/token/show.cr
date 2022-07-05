class BearerLogins::Token::Show < BrowserAction
  include Shield::BearerLogins::Token::Show

  skip :check_authorization
  skip :pin_login_to_ip_address

  get "/bearer-logins/token" do
    html ShowPage, bearer_login: bearer_login?, token: token?
  end
end
