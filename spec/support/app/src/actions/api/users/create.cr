class Api::Users::Create < ApiAction
  include Shield::Api::Users::Create

  skip :pin_login_to_ip_address
  skip :check_authorization

  post "/users" do
    run_operation
  end
end
