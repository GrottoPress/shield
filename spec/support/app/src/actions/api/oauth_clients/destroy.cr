class Api::OauthClients::Destroy < ApiAction
  include Shield::Api::OauthClients::Destroy

  skip :pin_login_to_ip_address

  delete "/oauth/clients/:oauth_client_id" do
    run_operation
  end
end
