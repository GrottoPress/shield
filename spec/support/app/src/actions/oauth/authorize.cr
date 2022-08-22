class Oauth::Authorize < BrowserAction
  include Shield::Oauth::Authorize

  skip :pin_login_to_ip_address

  get "/oauth/authorize" do
    run_operation
  end
end
