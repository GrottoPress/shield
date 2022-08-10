class CurrentUser::OauthClients::Index < BrowserAction
  include Shield::CurrentUser::OauthClients::Index

  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/account/oauth/clients" do
    html IndexPage, oauth_clients: oauth_clients, pages: pages
  end
end
