class Api::Logins::Delete < ApiAction
  include Shield::Api::Logins::Delete

  skip :pin_login_to_ip_address

  delete "/logins/delete/:login_id" do
    run_operation
  end
end
