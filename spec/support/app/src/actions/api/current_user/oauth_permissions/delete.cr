class Api::CurrentUser::OauthPermissions::Delete < ApiAction
  include Shield::Api::CurrentUser::OauthPermissions::Delete

  skip :pin_login_to_ip_address

  delete "/account/oauth/permissions/:oauth_client_id/delete" do
    run_operation
  end
end
