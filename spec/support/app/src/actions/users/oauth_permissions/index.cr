class Users::OauthPermissions::Index < BrowserAction
  include Shield::Users::OauthPermissions::Index

  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/users/:user_id/oauth/permissions" do
    html IndexPage, oauth_clients: oauth_clients, user: user, pages: pages
  end
end
