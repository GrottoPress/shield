class Api::Logins::Show < ApiAction
  include Shield::Api::Logins::Show

  skip :check_authorization
  skip :pin_login_to_ip_address

  get "/logins/:login_id" do
    json LoginSerializer.new(login: login)
  end
end
