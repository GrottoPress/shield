class Api::PasswordResets::Token::Verify < ApiAction
  include Shield::Api::PasswordResets::Token::Verify

  skip :pin_login_to_ip_address
  skip :pin_password_reset_to_ip_address

  post "/password-resets/token/verify" do
    run_operation
  end

  def remote_ip? : Socket::IPAddress?
    Socket::IPAddress.new("128.0.0.2", 5000)
  end
end
