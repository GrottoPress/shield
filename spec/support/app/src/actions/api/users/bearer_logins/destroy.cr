class Api::Users::BearerLogins::Destroy < ApiAction
  include Shield::Api::Users::BearerLogins::Destroy

  skip :pin_login_to_ip_address

  delete "/users/:user_id/bearer-logins" do
    run_operation
  end
end
