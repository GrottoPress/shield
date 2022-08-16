class Api::Users::OauthAuthorizations::Destroy < ApiAction
  include Shield::Api::Users::OauthAuthorizations::Destroy

  skip :pin_login_to_ip_address

  delete "/users/:user_id/oauth/authorizations" do
    run_operation
  end
end
