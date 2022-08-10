class Api::OauthClients::Update < ApiAction
  include Shield::Api::OauthClients::Update

  skip :check_authorization
  skip :pin_login_to_ip_address

  patch "/oauth/clients/:oauth_client_id" do
    run_operation
  end
end
