class OauthAuthorizations::Show < BrowserAction
  include Shield::OauthAuthorizations::Show

  skip :check_authorization
  skip :pin_login_to_ip_address

  get "/oauth/authorizations/:oauth_authorization_id" do
    html ShowPage, oauth_authorization: oauth_authorization
  end
end
