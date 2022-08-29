class OauthGrants::Index < BrowserAction
  include Shield::OauthGrants::Index

  skip :check_authorization
  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/oauth/grants" do
    html IndexPage, oauth_grants: oauth_grants, pages: pages
  end
end
