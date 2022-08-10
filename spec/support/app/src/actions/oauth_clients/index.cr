class OauthClients::Index < BrowserAction
  include Shield::OauthClients::Index

  skip :check_authorization
  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/oauth/clients" do
    html IndexPage, oauth_clients: oauth_clients, pages: pages
  end
end
