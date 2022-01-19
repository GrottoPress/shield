class Api::LoginsEverywhere::Delete < ApiAction
  include Shield::Api::LoginsEverywhere::Delete

  delete "/login/delete/all" do
    run_operation
  end

  def remote_ip? : Socket::IPAddress?
    Socket::IPAddress.new("128.0.0.2", 5000)
  end
end
