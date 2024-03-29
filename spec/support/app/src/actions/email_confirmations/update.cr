class EmailConfirmations::Update < BrowserAction
  include Shield::EmailConfirmations::Update

  skip :pin_email_confirmation_to_ip_address
  skip :pin_login_to_ip_address

  get "/email-confirmations/update" do
    run_operation
  end

  def do_verify_operation_failed(utility)
    response.headers["X-Email-Confirmation-Status"] = "failure"
    previous_def
  end
end
