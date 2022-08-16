class Api::CurrentUser::OauthAuthorizations::Delete < ApiAction
  include Shield::Api::CurrentUser::OauthAuthorizations::Delete

  skip :pin_login_to_ip_address

  delete "/account/oauth/authorizations/delete" do
    run_operation
  end
end
