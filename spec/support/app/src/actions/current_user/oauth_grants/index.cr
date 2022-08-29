class CurrentUser::OauthGrants::Index < BrowserAction
  include Shield::CurrentUser::OauthGrants::Index

  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/account/oauth/grants" do
    html IndexPage, oauth_grants: oauth_grants, pages: pages
  end
end
