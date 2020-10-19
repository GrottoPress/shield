class CurrentLogin::Destroy < BrowserAction
  include Shield::CurrentLogin::Destroy

  delete "/log-out" do
    run_operation
  end

  def do_run_operation_succeeded(operation, updated_login)
    json({a: ""})
  end

  def do_run_operation_failed(operation)
    json({a: ""})
  end
end
