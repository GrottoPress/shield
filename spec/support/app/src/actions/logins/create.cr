class Logins::Create < ApiAction
  include Shield::Logins::Create

  post "/log-in" do
    run_operation
  end

  def do_run_operation_succeeded(operation, login)
    json({
      login: login.id,
      session: LoginSession.new(session).login_id!,
      current_login: current_login!.id,
      current_user: current_user!.id
    })
  end

  def do_run_operation_failed(operation)
    json({errors: operation.errors})
  end

  def remote_ip : Socket::IPAddress?
    Socket::IPAddress.new("128.0.0.2", 5000)
  end
end
