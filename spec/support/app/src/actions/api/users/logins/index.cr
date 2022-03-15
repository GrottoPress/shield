class Api::Users::Logins::Index < ApiAction
  include Shield::Api::Users::Logins::Index

  skip :pin_login_to_ip_address

  param page : Int32 = 1

  get "/users/:user_id/logins" do
    json LoginSerializer.new(logins: logins, user: user, pages: pages)
  end
end
