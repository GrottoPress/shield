class Api::BearerLogins::Show < ApiAction
  include Shield::Api::BearerLogins::Show

  skip :check_authorization
  skip :pin_login_to_ip_address

  get "/bearer-logins/:bearer_login_id" do
    json BearerLoginSerializer.new(bearer_login: bearer_login)
  end
end
