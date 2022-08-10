class Api::Users::OauthClients::Delete < ApiAction
  include Shield::Api::Users::OauthClients::Delete

  skip :pin_login_to_ip_address

  delete "/users/:user_id/oauth/clients/delete" do
    run_operation
  end
end
