class BearerLogins::Create < BrowserAction
  include Shield::BearerLogins::Create

  skip :pin_login_to_ip_address

  post "/bearer-logins" do
    run_operation
  end

  def do_run_operation_succeeded(operation, bearer_login)
    response.headers["X-Bearer-Login-ID"] = bearer_login.id.to_s
    response.headers["X-User-ID"] = bearer_login.user_id.to_s
    previous_def
  end
end
