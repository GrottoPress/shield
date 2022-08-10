class OauthClients::Delete < BrowserAction
  include Shield::OauthClients::Delete

  skip :pin_login_to_ip_address

  delete "/oauth/clients/delete/:oauth_client_id" do
    run_operation
  end

  def do_run_operation_succeeded(operation, oauth_client)
    response.headers["X-OAuth-Client-ID"] = oauth_client.id.to_s
    previous_def
  end
end
