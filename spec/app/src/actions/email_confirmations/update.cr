class EmailConfirmations::Update < ApiAction
  include Shield::EmailConfirmations::Update

  skip :pin_email_confirmation_to_ip_address
  skip :pin_login_to_ip_address

  patch "/email-confirmations" do
    run_operation
  end

  def do_run_operation_succeeded(operation, user)
    json({status: 0})
  end

  def do_run_operation_failed(operation, user)
    json({status: 1})
  end

  def authorize? : Bool
    true
  end
end
