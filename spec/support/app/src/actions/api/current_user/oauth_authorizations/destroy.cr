class Api::CurrentUser::OauthAuthorizations::Destroy < ApiAction
  include Shield::Api::CurrentUser::OauthAuthorizations::Destroy

  skip :pin_login_to_ip_address

  delete "/account/oauth/authorizations" do
    run_operation
  end
end
