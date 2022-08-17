class Users::OauthAccessTokens::Delete < BrowserAction
  include Shield::Users::OauthAccessTokens::Delete

  skip :pin_login_to_ip_address

  delete "/users/:user_id/oauth/tokens/delete" do
    run_operation
  end

  def do_run_operation_succeeded(operation, user)
    response.headers["X-User-ID"] = user.id.to_s
    previous_def
  end
end
