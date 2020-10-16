class CurrentUser::New < ApiAction
  include Shield::EmailConfirmationCurrentUser::New

  get "/register" do
    run_operation
  end

  private def render_form(utility, email_confirmation)
    json({exit: 0})
  end

  def do_verify_operation_failed(utility)
    json({exit: 1})
  end

  def remote_ip : Socket::IPAddress?
    Socket::IPAddress.new("128.0.0.2", 5000)
  end
end
