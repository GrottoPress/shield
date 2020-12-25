class BearerLogins::Destroy < BrowserAction
  include Shield::BearerLogins::Destroy

  skip :pin_login_to_ip_address

  delete "/bearer-logins/:bearer_login_id" do
    run_operation
  end

  def do_run_operation_succeeded(operation, bearer_login)
    response.headers["X-Bearer-Login-ID"] = bearer_login.id.to_s
    previous_def
  end
end
