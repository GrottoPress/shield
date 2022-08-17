class Api::Users::OauthAccessTokens::Delete < ApiAction
  include Shield::Api::Users::OauthAccessTokens::Delete

  skip :pin_login_to_ip_address

  delete "/users/:user_id/oauth/tokens/delete" do
    run_operation
  end
end
