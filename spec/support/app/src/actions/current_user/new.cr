class CurrentUser::New < BrowserAction
  include Shield::EmailConfirmationCurrentUser::New

  get "/ec/new" do
    run_operation
  end

  def do_verify_operation_failed(utility)
    response.headers["X-Email-Confirmation-Status"] = "failure"
    previous_def
  end

  def remote_ip : Socket::IPAddress?
    Socket::IPAddress.new("128.0.0.2", 5000)
  end
end
