class Users::OauthClients::Index < BrowserAction
  include Shield::Users::OauthClients::Index

  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/users/:user_id/oauth/clients" do
    html IndexPage, oauth_clients: oauth_clients, user: user, pages: pages
  end
end
