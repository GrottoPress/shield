class PasswordResets::Update < ApiAction
  include Shield::PasswordResets::Update

  patch "/password-resets" do
    run_operation
  end

  def do_run_operation_succeeded(operation, user)
    json({a: ""})
  end

  def do_run_operation_failed(operation, user)
    json({a: ""})
  end

  def remote_ip : Socket::IPAddress?
    Socket::IPAddress.new("127.0.0.1", 6000)
  end
end
