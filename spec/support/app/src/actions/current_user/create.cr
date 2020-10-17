class CurrentUser::Create < BrowserAction
  include Shield::CurrentUser::Create

  post "/register" do
    run_operation
  end

  def do_verify_operation_failed(utility)
    json({exit: 0})
  end

  def do_run_operation_succeeded(operation, user)
    json({user: user.id})
  end

  def do_run_operation_failed(operation)
    json({errors: operation.errors})
  end
end
