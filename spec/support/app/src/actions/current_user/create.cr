class CurrentUser::Create < BrowserAction
  include Shield::CurrentUser::Create

  post "/register" do
    run_operation
  end

  def do_run_operation_succeeded(operation, user)
    response.headers["X-User-ID"] = "current_user_id"
    previous_def
  end
end
