class Api::CurrentUser::BearerLogins::Destroy < ApiAction
  include Shield::Api::CurrentUser::BearerLogins::Destroy

  skip :pin_login_to_ip_address

  delete "/account/bearer-logins" do
    run_operation
  end
end
