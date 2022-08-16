class Users::OauthAuthorizations::Delete < BrowserAction
  include Shield::Users::OauthAuthorizations::Delete

  skip :pin_login_to_ip_address

  delete "/users/:user_id/oauth/authorizations/delete" do
    run_operation
  end

  def do_run_operation_succeeded(operation, user)
    response.headers["X-User-ID"] = user.id.to_s
    previous_def
  end
end
