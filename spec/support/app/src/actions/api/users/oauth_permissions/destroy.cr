class Api::Users::OauthPermissions::Destroy < ApiAction
  include Shield::Api::Users::OauthPermissions::Destroy

  skip :pin_login_to_ip_address

  delete "/users/:user_id/oauth/permissions/:oauth_client_id" do
    run_operation
  end
end
