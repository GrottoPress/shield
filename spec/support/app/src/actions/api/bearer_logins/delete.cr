class Api::BearerLogins::Delete < ApiAction
  include Shield::Api::BearerLogins::Delete

  skip :pin_login_to_ip_address

  delete "/bearer-logins/delete/:bearer_login_id" do
    run_operation
  end
end
