class EmailConfirmations::Create < BrowserAction
  include Shield::EmailConfirmations::Create

  post "/email-confirmations" do
    run_operation
  end

  def do_run_operation_succeeded(operation, email_confirmation)
    response.headers["X-Email-Confirmation-ID"] = "ec_id"
    previous_def
  end

  private def success_action(operation)
    response.headers["X-Email-Confirmation-Status"] = "success"
    previous_def
  end
end
