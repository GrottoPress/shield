class Api::PasswordResets::Token::Verify < ApiAction
  include Shield::Api::PasswordResets::Token::Verify

  post "/password-resets/token/verify" do
    run_operation
  end

  def remote_ip? : Socket::IPAddress?
    Socket::IPAddress.new("128.0.0.2", 5000)
  end
end
