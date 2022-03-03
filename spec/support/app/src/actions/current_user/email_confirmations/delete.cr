class CurrentUser::EmailConfirmations::Delete < BrowserAction
  include Shield::CurrentUser::EmailConfirmations::Delete

  delete "/account/email-confirmations/delete" do
    run_operation
  end

  def do_run_operation_succeeded(operation, email_confirmation)
    response.headers["X-End-Email-Confirmations"] = "true"
    previous_def
  end

  def remote_ip? : Socket::IPAddress?
    Socket::IPAddress.new("128.0.0.2", 5000)
  end
end
