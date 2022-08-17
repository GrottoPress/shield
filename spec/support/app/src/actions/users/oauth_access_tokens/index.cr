class Users::OauthAccessTokens::Index < BrowserAction
  include Shield::Users::OauthAccessTokens::Index

  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/users/:user_id/oauth/tokens" do
    html BearerLogins::IndexPage,
      bearer_logins: bearer_logins,
      user: user,
      pages: pages
  end
end
