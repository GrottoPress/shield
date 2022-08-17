class Api::OauthPermissions::Destroy < ApiAction
  include Shield::Api::OauthPermissions::Destroy

  skip :pin_login_to_ip_address

  delete "/oauth/clients/:oauth_client_id/users/:user_id" do
    run_operation
  end
end
