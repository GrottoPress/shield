class Users::OauthClients::Destroy < BrowserAction
  include Shield::Users::OauthClients::Destroy

  skip :pin_login_to_ip_address

  delete "/users/:user_id/oauth/clients" do
    run_operation
  end

  def do_run_operation_succeeded(operation, user)
    response.headers["X-User-ID"] = user.id.to_s
    previous_def
  end
end
