class Api::OauthClients::Secret::Update < ApiAction
  include Shield::Api::OauthClients::Secret::Update

  skip :check_authorization
  skip :pin_login_to_ip_address

  patch "/oauth/clients/:oauth_client_id/secret" do
    run_operation
  end
end
