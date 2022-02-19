class Api::CurrentLogins::Destroy < ApiAction
  include Shield::Api::CurrentLogins::Destroy

  delete "/account/logins" do
    run_operation
  end

  def remote_ip? : Socket::IPAddress?
    Socket::IPAddress.new("128.0.0.2", 5000)
  end
end
