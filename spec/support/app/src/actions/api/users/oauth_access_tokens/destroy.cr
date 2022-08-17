class Api::Users::OauthAccessTokens::Destroy < ApiAction
  include Shield::Api::Users::OauthAccessTokens::Destroy

  skip :pin_login_to_ip_address

  delete "/users/:user_id/oauth/tokens" do
    run_operation
  end
end
