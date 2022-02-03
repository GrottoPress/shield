class Api::PasswordResets::Verify < ApiAction
  include Shield::Api::PasswordResets::Verify

  post "/password-resets/verify" do
    run_operation
  end

  def remote_ip? : Socket::IPAddress?
    Socket::IPAddress.new("128.0.0.2", 5000)
  end
end
