class Api::CurrentUser::BearerLogins::Delete < ApiAction
  include Shield::Api::CurrentUser::BearerLogins::Delete

  skip :pin_login_to_ip_address

  delete "/account/bearer-logins/delete" do
    run_operation
  end
end
