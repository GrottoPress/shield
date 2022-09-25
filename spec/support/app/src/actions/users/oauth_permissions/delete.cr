class Users::OauthPermissions::Delete < BrowserAction
  include Shield::Users::OauthPermissions::Delete

  skip :pin_login_to_ip_address

  delete "/users/:user_id/oauth/permissions/:oauth_client_id/delete" do
    run_operation
  end

  def do_run_operation_succeeded(operation, oauth_client)
    response.headers["X-OAuth-Client-ID"] = oauth_client.id.to_s
    previous_def
  end
end
