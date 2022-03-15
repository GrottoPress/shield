class Api::Users::Index < ApiAction
  include Shield::Api::Users::Index

  skip :pin_login_to_ip_address
  skip :check_authorization

  param page : Int32 = 1

  get "/users" do
    json UserSerializer.new(users: users, pages: pages)
  end
end
