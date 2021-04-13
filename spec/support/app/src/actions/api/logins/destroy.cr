class Api::Logins::Destroy < ApiAction
  include Shield::Api::Logins::Destroy

  skip :pin_login_to_ip_address

  delete "/logins/:login_id" do
    run_operation
  end
end
