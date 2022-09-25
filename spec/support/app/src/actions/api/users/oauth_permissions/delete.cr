class Api::Users::OauthPermissions::Delete < ApiAction
  include Shield::Api::Users::OauthPermissions::Delete

  skip :pin_login_to_ip_address

  delete "/users/:user_id/oauth/permissions/:oauth_client_id/delete" do
    run_operation
  end
end
