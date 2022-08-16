class CurrentUser::OauthAuthorizations::Index < BrowserAction
  include Shield::CurrentUser::OauthAuthorizations::Index

  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/account/oauth/authorizations" do
    html IndexPage, oauth_authorizations: oauth_authorizations, pages: pages
  end
end
