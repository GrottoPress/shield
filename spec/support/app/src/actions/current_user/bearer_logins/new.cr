class CurrentUser::BearerLogins::New < BrowserAction
  include Shield::CurrentUser::BearerLogins::New

  skip :pin_login_to_ip_address

  get "/account/bearer-logins/new" do
    operation = CreateBearerLogin.new(user: user)
    html NewPage, operation: operation
  end
end
