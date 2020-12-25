class Api::Users::Update < ApiAction
  include Shield::Api::Users::Update

  skip :pin_login_to_ip_address
  skip :check_authorization

  patch "/users/:user_id" do
    run_operation
  end
end
