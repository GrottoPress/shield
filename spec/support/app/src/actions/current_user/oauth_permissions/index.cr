class CurrentUser::OauthPermissions::Index < BrowserAction
  include Shield::CurrentUser::OauthPermissions::Index

  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/account/oauth/permissions" do
    html IndexPage, oauth_clients: oauth_clients, pages: pages
  end
end
