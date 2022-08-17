class Api::OauthPermissions::Delete < ApiAction
  include Shield::Api::OauthPermissions::Delete

  skip :pin_login_to_ip_address

  delete "/oauth/clients/:oauth_client_id/users/:user_id/delete" do
    run_operation
  end
end
