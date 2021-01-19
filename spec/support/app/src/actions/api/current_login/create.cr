class Api::CurrentLogin::Create < ApiAction
  include Shield::Api::CurrentLogin::Create
  include Shield::Api::SkipAuthenticationCache

  post "/log-in" do
    run_operation
  end

  def remote_ip : Socket::IPAddress?
    Socket::IPAddress.new("128.0.0.2", 5000)
  end
end
