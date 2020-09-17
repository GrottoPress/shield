class CurrentUser::New < ApiAction
  include Shield::EmailConfirmationCurrentUser::New

  get "/register" do
    run_operation
  end

  def do_run_operation_succeeded(utility, email_confirmation)
    json({exit: 0})
  end

  def do_run_operation_failed(utility)
    json({exit: 1})
  end

  def remote_ip : Socket::IPAddress?
    Socket::IPAddress.new("128.0.0.2", 5000)
  end
end
