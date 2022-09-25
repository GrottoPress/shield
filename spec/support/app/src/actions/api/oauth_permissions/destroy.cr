class Api::OauthPermissions::Destroy < ApiAction
  include Shield::Api::OauthPermissions::Destroy

  skip :pin_login_to_ip_address

  delete "/oauth/permissions/:oauth_client_id/:user_id" do
    run_operation
  end
end
