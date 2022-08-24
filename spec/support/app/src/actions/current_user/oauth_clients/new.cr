class CurrentUser::OauthClients::New < BrowserAction
  include Shield::CurrentUser::OauthClients::New

  skip :pin_login_to_ip_address

  get "/account/oauth/clients/new" do
    operation = RegisterOauthClient.new(user: user)
    html NewPage, operation: operation
  end
end
