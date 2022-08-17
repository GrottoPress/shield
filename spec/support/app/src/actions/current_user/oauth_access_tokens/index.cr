class CurrentUser::OauthAccessTokens::Index < BrowserAction
  include Shield::CurrentUser::OauthAccessTokens::Index

  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/account/oauth/tokens" do
    html BearerLogins::IndexPage, bearer_logins: bearer_logins, pages: pages
  end
end
