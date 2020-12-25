class EmailConfirmationCurrentUser::New < BrowserAction
  include Shield::EmailConfirmationCurrentUser::New

  get "/ec/new" do
    run_operation
  end

  private def render_form(utility, email_confirmation)
    operation = RegisterEmailConfirmationCurrentUser.new(
      email_confirmation: email_confirmation
    );

    html NewPage, operation: operation
  end

  def do_verify_operation_failed(utility)
    response.headers["X-Email-Confirmation-Status"] = "failure"
    previous_def
  end

  def remote_ip : Socket::IPAddress?
    Socket::IPAddress.new("128.0.0.2", 5000)
  end
end
