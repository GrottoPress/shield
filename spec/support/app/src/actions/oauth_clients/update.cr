class OauthClients::Update < BrowserAction
  include Shield::OauthClients::Update

  skip :check_authorization
  skip :pin_login_to_ip_address

  patch "/oauth/clients/:oauth_client_id" do
    run_operation
  end

  def do_run_operation_succeeded(operation, oauth_client)
    response.headers["X-OAuth-Client-ID"] = oauth_client.id.to_s
    previous_def
  end
end
