class RegularCurrentUser::Create < BrowserAction
  include Shield::CurrentUser::Create

  post "/register" do
    run_operation
  end

  def run_operation
    RegisterRegularCurrentUser.create(params) do |operation, user|
      if operation.saved?
        do_run_operation_succeeded(operation, user.not_nil!)
      else
        do_run_operation_failed(operation)
      end
    end
  end

  def do_run_operation_succeeded(operation, user)
    response.headers["X-User-ID"] = "current_user_id"
    previous_def
  end

  private def success_action(operation)
    response.headers["X-User-Created"] = "true"
    previous_def
  end
end
