class PasswordResets::Update < BrowserAction
  include Shield::PasswordResets::Update

  patch "/password-resets" do
    run_operation
  end

  def do_verify_operation_failed(utility)
    response.headers["X-Password-Reset-Status"] = "failure"
    previous_def
  end

  def remote_ip? : Socket::IPAddress?
    Socket::IPAddress.new("129.0.0.5", 6000)
  end
end
