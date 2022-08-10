class OauthClients::Show < BrowserAction
  include Shield::OauthClients::Show

  skip :check_authorization
  skip :pin_login_to_ip_address

  get "/oauth/clients/:oauth_client_id" do
    html ShowPage, oauth_client: oauth_client
  end
end
