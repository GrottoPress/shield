class CurrentUser::Create < BrowserAction
  include Shield::EmailConfirmationCurrentUser::Create

  skip :pin_email_confirmation_to_ip_address

  post "/ec" do
    run_operation
  end

  def do_verify_operation_failed(utility)
    response.headers["X-Email-Confirmation-Status"] = "failure"
    previous_def
  end

  def do_run_operation_succeeded(operation, user)
    response.headers["X-User-ID"] = "ec_user_id"
    previous_def
  end
end
