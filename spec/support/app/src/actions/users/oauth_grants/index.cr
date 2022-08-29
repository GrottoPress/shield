class Users::OauthGrants::Index < BrowserAction
  include Shield::Users::OauthGrants::Index

  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/users/:user_id/oauth/grants" do
    html IndexPage, oauth_grants: oauth_grants, user: user, pages: pages
  end
end
