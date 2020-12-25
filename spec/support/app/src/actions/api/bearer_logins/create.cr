class Api::BearerLogins::Create < ApiAction
  include Shield::Api::BearerLogins::Create

  skip :pin_login_to_ip_address

  post "/bearer-logins" do
    run_operation
  end
end
