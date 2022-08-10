class CurrentUser::OauthClients::Create < BrowserAction
  include Shield::CurrentUser::OauthClients::Create

  skip :pin_login_to_ip_address

  post "/account/oauth/clients" do
    run_operation
  end

  def do_run_operation_succeeded(operation, oauth_client)
    response.headers["X-OAuth-Client-ID"] = oauth_client.id.to_s
    response.headers["X-User-ID"] = oauth_client.user_id.to_s
    previous_def
  end
end
