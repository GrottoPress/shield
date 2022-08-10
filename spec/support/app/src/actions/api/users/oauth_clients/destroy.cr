class Api::Users::OauthClients::Destroy < ApiAction
  include Shield::Api::Users::OauthClients::Destroy

  skip :pin_login_to_ip_address

  delete "/users/:user_id/oauth/clients" do
    run_operation
  end
end
