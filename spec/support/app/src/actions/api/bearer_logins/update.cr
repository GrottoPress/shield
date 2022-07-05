class Api::BearerLogins::Update < ApiAction
  include Shield::Api::BearerLogins::Update

  skip :check_authorization
  skip :pin_login_to_ip_address

  patch "/bearer-logins/:bearer_login_id" do
    run_operation
  end
end
