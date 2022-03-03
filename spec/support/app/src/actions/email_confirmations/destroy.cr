class EmailConfirmations::Destroy < BrowserAction
  include Shield::EmailConfirmations::Destroy

  skip :pin_login_to_ip_address

  delete "/email-confirmations/:email_confirmation_id" do
    run_operation
  end

  def do_run_operation_succeeded(operation, email_confirmation)
    response.headers["X-Email-Confirmation-ID"] = email_confirmation.id.to_s
    previous_def
  end
end
