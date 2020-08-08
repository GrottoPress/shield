class CurrentUser::Create < ApiAction
  include Shield::CurrentUser::Create

  post "/register" do
    run_operation
  end

  def do_run_operation_succeeded(operation, user)
    json({user: user.id})
  end

  def do_run_operation_failed(operation)
    json({errors: operation.errors})
  end
end
