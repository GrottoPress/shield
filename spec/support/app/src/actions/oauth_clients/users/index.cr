class OauthClients::Users::Index < BrowserAction
  include Shield::OauthClients::Users::Index

  skip :check_authorization
  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/oauth/clients/:oauth_client_id/users" do
    html IndexPage, users: users, oauth_client: oauth_client, pages: pages
  end
end
