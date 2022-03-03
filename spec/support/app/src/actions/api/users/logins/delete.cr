class Api::Users::Logins::Delete < ApiAction
  include Shield::Api::Users::Logins::Delete

  skip :pin_login_to_ip_address

  delete "/users/:user_id/logins/delete" do
    run_operation
  end
end
