class Logins::Destroy < BrowserAction
  include Shield::Logins::Destroy

  skip :pin_login_to_ip_address

  delete "/logins/:login_id" do
    run_operation
  end

  def do_run_operation_succeeded(operation, login)
    response.headers["X-Login-ID"] = login.id.to_s
    previous_def
  end
end
