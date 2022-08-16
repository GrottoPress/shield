class Api::OauthAuthorizations::Destroy < ApiAction
  include Shield::Api::OauthAuthorizations::Destroy

  skip :pin_login_to_ip_address

  delete "/oauth/authorizations/:oauth_authorization_id" do
    run_operation
  end
end
