class Api::CurrentUser::BearerLogins::Create < ApiAction
  include Shield::Api::CurrentUser::BearerLogins::Create

  skip :pin_login_to_ip_address

  post "/account/bearer-logins" do
    run_operation
  end
end
