class Api::OauthPermissions::Delete < ApiAction
  include Shield::Api::OauthPermissions::Delete

  skip :pin_login_to_ip_address

  delete "/oauth/permissions/:oauth_client_id/:user_id/delete" do
    run_operation
  end
end
