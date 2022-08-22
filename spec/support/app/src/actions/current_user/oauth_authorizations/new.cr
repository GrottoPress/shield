class CurrentUser::OauthAuthorizations::New < BrowserAction
  include Shield::CurrentUser::OauthAuthorizations::New

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

  get "/account/oauth/authorizations/new" do
    operation = StartOauthAuthorization.new(
      redirect_uri: redirect_uri.to_s,
      response_type: response_type.to_s,
      code_challenge: code_challenge.to_s,
      code_challenge_method: code_challenge_method,
      state: state.to_s,
      scopes: scopes,
      user: user,
      oauth_client: oauth_client?,
    )

    html NewPage, operation: operation
  end
end