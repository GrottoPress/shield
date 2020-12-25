class EmailConfirmationCurrentUser::Create < BrowserAction
  include Shield::EmailConfirmationCurrentUser::Create

  skip :pin_email_confirmation_to_ip_address

  post "/ec" do
    run_operation
  end

  private def register_user(email_confirmation)
    RegisterEmailConfirmationCurrentUser.create(
      params,
      email_confirmation: email_confirmation,
      session: session,
    ) do |operation, user|
      if user
        do_run_operation_succeeded(operation, user.not_nil!)
      else
        do_run_operation_failed(operation)
      end
    end
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
