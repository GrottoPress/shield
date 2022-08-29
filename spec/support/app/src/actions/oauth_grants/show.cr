class OauthGrants::Show < BrowserAction
  include Shield::OauthGrants::Show

  skip :check_authorization
  skip :pin_login_to_ip_address

  get "/oauth/grants/:oauth_grant_id" do
    html ShowPage, oauth_grant: oauth_grant
  end
end
