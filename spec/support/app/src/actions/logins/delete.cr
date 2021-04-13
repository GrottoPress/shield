class Logins::Delete < BrowserAction
  include Shield::Logins::Delete

  skip :pin_login_to_ip_address

  delete "/logins/delete/:login_id" do
    run_operation
  end

  def do_run_operation_succeeded(operation, login)
    response.headers["X-Login-ID"] = login.id.to_s
    previous_def
  end
end
