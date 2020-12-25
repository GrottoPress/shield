class Users::New < BrowserAction
  include Shield::Users::New

  skip :pin_login_to_ip_address
  skip :check_authorization

  get "/users/new" do
    operation = RegisterUser.new
    html NewPage, operation: operation
  end
end
