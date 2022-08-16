class Users::OauthAuthorizations::Index < BrowserAction
  include Shield::Users::OauthAuthorizations::Index

  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/users/:user_id/oauth/authorizations" do
    html IndexPage,
      oauth_authorizations: oauth_authorizations,
      user: user,
      pages: pages
  end
end
