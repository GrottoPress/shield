class BearerLogins::Edit < BrowserAction
  include Shield::BearerLogins::Edit

  skip :check_authorization
  skip :pin_login_to_ip_address

  get "/bearer-logins/:bearer_login_id/edit" do
    operation = UpdateBearerLogin.new(bearer_login)
    html EditPage, operation: operation
  end
end
