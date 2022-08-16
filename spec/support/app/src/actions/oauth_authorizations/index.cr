class OauthAuthorizations::Index < BrowserAction
  include Shield::OauthAuthorizations::Index

  skip :check_authorization
  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/oauth/authorizations" do
    html IndexPage, oauth_authorizations: oauth_authorizations, pages: pages
  end
end
