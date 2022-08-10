class Api::OauthClients::Delete < ApiAction
  include Shield::Api::OauthClients::Delete

  skip :pin_login_to_ip_address

  delete "/oauth/clients/:oauth_client_id/delete" do
    run_operation
  end
end
