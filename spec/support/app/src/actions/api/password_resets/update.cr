class Api::PasswordResets::Update < ApiAction
  include Shield::Api::PasswordResets::Update

  patch "/password-resets" do
    run_operation
  end

  def remote_ip : Socket::IPAddress?
    Socket::IPAddress.new("128.0.0.2", 5000)
  end
end
