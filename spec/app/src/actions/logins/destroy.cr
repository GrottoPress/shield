class Logins::Destroy < ApiAction
  include Shield::DestroyLogin

  delete "/log-out" do
    log_user_out
  end

  private def success_action(operation, updated_login)
    json({a: ""})
  end

  private def failure_action(operation, updated_login)
    json({a: ""})
  end
end
