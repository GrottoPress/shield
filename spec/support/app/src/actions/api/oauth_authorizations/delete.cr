class Api::OauthAuthorizations::Delete < ApiAction
  include Shield::Api::OauthAuthorizations::Delete

  skip :pin_login_to_ip_address

  delete "/oauth/authorizations/:oauth_authorization_id/delete" do
    run_operation
  end
end
