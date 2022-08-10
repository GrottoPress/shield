class OauthClients::Edit < BrowserAction
  include Shield::OauthClients::Edit

  skip :check_authorization
  skip :pin_login_to_ip_address

  get "/oauth/clients/:oauth_client_id/edit" do
    operation = UpdateOauthClient.new(oauth_client)
    html EditPage, operation: operation
  end
end
