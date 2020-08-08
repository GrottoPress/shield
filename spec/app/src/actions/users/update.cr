class Users::Update < ApiAction
  include Shield::Users::Update

  skip :require_logged_in
  skip :require_logged_out

  patch "/users/:user_id" do
    run_operation
  end

  def do_run_operation_succeeded(operation, user)
    json({user: user.id})
  end

  def do_run_operation_failed(operation, user)
    json({user: user.id, errors: operation.errors})
  end
end
