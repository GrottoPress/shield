class Oauth::Authorization::Create < BrowserAction
  include Shield::Oauth::Authorization::Create

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

  post "/oauth/authorization" do
    run_operation
  end

  def do_run_operation_succeeded(operation, oauth_grant)
    response.headers["X-OAuth-Grant-ID"] = oauth_grant.id.to_s
    previous_def
  end
end
