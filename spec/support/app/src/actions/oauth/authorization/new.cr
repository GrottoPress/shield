class Oauth::Authorization::New < BrowserAction
  include Shield::Oauth::Authorization::New

  skip :pin_login_to_ip_address
  skip :oauth_validate_client_id
  # skip :oauth_handle_errors
  skip :oauth_check_duplicate_params
  skip :oauth_require_authorization_params
  skip :oauth_validate_response_type
  skip :oauth_validate_redirect_uri
  skip :oauth_validate_scope
  skip :oauth_require_code_challenge
  skip :oauth_validate_code_challenge_method

  get "/oauth/authorization" do
    operation = StartOauthGrant.new(
      redirect_uri: redirect_uri.to_s,
      response_type: response_type.to_s,
      code_challenge: code_challenge.to_s,
      code_challenge_method: code_challenge_method,
      state: state.to_s,
      scopes: scopes,
      type: OauthGrantType.new(OauthGrantType::AUTHORIZATION_CODE),
      user: user,
      oauth_client: oauth_client?,
    )

    html NewPage, operation: operation
  end
end
