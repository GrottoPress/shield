class OauthAuthorizations::Init < BrowserAction
  include Shield::OauthAuthorizations::Init

  skip :pin_login_to_ip_address

  get "/oauth/authorize" do
    run_operation
  end
end
