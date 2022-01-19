class Api::LoginsEverywhere::Destroy < ApiAction
  include Shield::Api::LoginsEverywhere::Destroy

  delete "/login/all" do
    run_operation
  end

  def remote_ip? : Socket::IPAddress?
    Socket::IPAddress.new("128.0.0.2", 5000)
  end
end
