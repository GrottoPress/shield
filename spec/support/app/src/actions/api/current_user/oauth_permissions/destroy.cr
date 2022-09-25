class Api::CurrentUser::OauthPermissions::Destroy < ApiAction
  include Shield::Api::CurrentUser::OauthPermissions::Destroy

  skip :pin_login_to_ip_address

  delete "/accounts/oauth/permissions/:oauth_client_id" do
    run_operation
  end
end
