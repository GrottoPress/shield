class OauthPermissions::Delete < BrowserAction
  include Shield::OauthPermissions::Delete

  skip :pin_login_to_ip_address

  delete "/oauth/clients/:oauth_client_id/users/:user_id/delete" do
    run_operation
  end

  def do_run_operation_succeeded(operation, user)
    response.headers["X-User-ID"] = user.id.to_s
    previous_def
  end
end
