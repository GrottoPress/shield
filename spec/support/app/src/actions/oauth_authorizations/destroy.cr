class OauthAuthorizations::Destroy < BrowserAction
  include Shield::OauthAuthorizations::Destroy

  skip :pin_login_to_ip_address

  delete "/oauth/authorizations/:oauth_authorization_id" do
    run_operation
  end

  def do_run_operation_succeeded(operation, oauth_authorization)
    response.headers["X-OAuth-Authorization-ID"] = oauth_authorization.id.to_s
    previous_def
  end
end
