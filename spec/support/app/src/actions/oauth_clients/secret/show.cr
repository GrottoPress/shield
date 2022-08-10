class OauthClients::Secret::Show < BrowserAction
  include Shield::OauthClients::Secret::Show

  skip :check_authorization
  skip :pin_login_to_ip_address

  get "/oauth/clients/secret" do
    html ShowPage, oauth_client: oauth_client?, secret: secret?
  end
end
