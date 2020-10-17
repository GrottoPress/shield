class PasswordResets::Edit < BrowserAction
  include Shield::PasswordResets::Edit

  get "/password-resets/edit" do
    run_operation
  end

  private def render_form(utility, password_reset)
    json({exit: 0})
  end

  def do_verify_operation_failed(utility)
    json({exit: 1})
  end

  def remote_ip : Socket::IPAddress?
    Socket::IPAddress.new("128.0.0.2", 5000)
  end
end
