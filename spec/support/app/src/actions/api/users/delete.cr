class Api::Users::Delete < ApiAction
  include Shield::Api::Users::Delete

  skip :pin_login_to_ip_address
  skip :check_authorization

  delete "/users/:user_id" do
    run_operation
  end
end
