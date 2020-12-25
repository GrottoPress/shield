class BearerLogins::New < BrowserAction
  include Shield::BearerLogins::New

  skip :pin_login_to_ip_address

  get "/bearer-logins/new" do
    operation = CreateBearerLogin.new(all_scopes: ["api.posts.index"])
    html NewPage, operation: operation
  end
end
