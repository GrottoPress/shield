class EmailConfirmationCurrentUser::New < BrowserAction
  include Shield::EmailConfirmationCurrentUser::New

  get "/register" do
    run_operation
  end

  private def render_form(utility, email_confirmation)
    operation = RegisterEmailConfirmationCurrentUser.new(
      email_confirmation: email_confirmation
    );

    html NewPage, operation: operation
  end

  def remote_ip : Socket::IPAddress?
    Socket::IPAddress.new("128.0.0.2", 5000)
  end
end
