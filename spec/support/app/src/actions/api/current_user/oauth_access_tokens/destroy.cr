class Api::CurrentUser::OauthAccessTokens::Destroy < ApiAction
  include Shield::Api::CurrentUser::OauthAccessTokens::Destroy

  skip :pin_login_to_ip_address

  delete "/account/oauth/tokens" do
    run_operation
  end
end
