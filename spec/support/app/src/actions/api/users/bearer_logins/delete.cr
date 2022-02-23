class Api::Users::BearerLogins::Delete < ApiAction
  include Shield::Api::Users::BearerLogins::Delete

  skip :pin_login_to_ip_address

  delete "/users/:user_id/bearer-logins/delete" do
    run_operation
  end
end
