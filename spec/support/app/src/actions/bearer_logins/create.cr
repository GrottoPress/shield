class BearerLogins::Create < ApiAction
  include Shield::BearerLogins::Create

  skip :pin_login_to_ip_address

  post "/bearer-logins" do
    run_operation
  end

  def do_run_operation_succeeded(operation, bearer_login)
    json({
      bearer_login: bearer_login.id,
      bearer_token: operation.token,
      session: 1,
    })
  end

  def do_run_operation_failed(operation)
    json({errors: operation.errors})
  end
end
