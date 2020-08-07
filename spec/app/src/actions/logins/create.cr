class Logins::Create < ApiAction
  include Shield::Logins::Create

  post "/log-in" do
    log_user_in
  end

  private def success_action(operation, login)
    json({
      login: login.id,
      session: LoginSession.new(session).login_id!,
      current_login: current_login!.id,
      current_user: current_user!.id
    })
  end

  private def failure_action(operation)
    json({errors: operation.errors})
  end
end
