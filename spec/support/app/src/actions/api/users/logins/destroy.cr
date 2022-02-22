class Api::Users::Logins::Destroy < ApiAction
  include Shield::Api::Users::Logins::Destroy

  skip :pin_login_to_ip_address

  delete "/users/:user_id/logins" do
    run_operation
  end

  def remote_ip? : Socket::IPAddress?
    Socket::IPAddress.new("128.0.0.2", 5000)
  end
end
