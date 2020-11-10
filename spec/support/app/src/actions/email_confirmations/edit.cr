class EmailConfirmations::Edit < BrowserAction
  include Shield::EmailConfirmations::Edit

  skip :pin_email_confirmation_to_ip_address
  skip :pin_login_to_ip_address

  get "/email-confirmations/edit" do
    run_operation
  end

  def do_run_operation_succeeded(operation, user)
    flash.keep.success = "Email changed successfully"
    redirect to: EmailConfirmationCurrentUser::Show
  end

  def do_run_operation_failed(operation)
    flash.failure = "Could not change email"
    html EmailConfirmationCurrentUser::EditPage, operation: operation
  end
end
