class Api::BearerLogins::Destroy < ApiAction
  include Shield::Api::BearerLogins::Destroy

  skip :pin_login_to_ip_address

  delete "/bearer-logins/:bearer_login_id" do
    run_operation
  end
end
