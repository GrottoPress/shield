class Api::Users::OauthAuthorizations::Delete < ApiAction
  include Shield::Api::Users::OauthAuthorizations::Delete

  skip :pin_login_to_ip_address

  delete "/users/:user_id/oauth/authorizations/delete" do
    run_operation
  end
end
