class PasswordResets::Edit < ApiAction
  include Shield::PasswordResets::Edit

  get "/password-resets/edit" do
    run_operation
  end

  def do_run_operation_succeeded(operation, password_reset)
    json({exit: 0})
  end

  def do_run_operation_failed(operation)
    json({exit: 1})
  end

  def remote_ip : Socket::IPAddress?
    Socket::IPAddress.new("128.0.0.2", 5000)
  end
end
