class Api::CurrentUser::OauthAccessTokens::Delete < ApiAction
  include Shield::Api::CurrentUser::OauthAccessTokens::Delete

  skip :pin_login_to_ip_address

  delete "/account/oauth/tokens/delete" do
    run_operation
  end
end
