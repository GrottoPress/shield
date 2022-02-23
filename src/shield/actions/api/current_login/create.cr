module Shield::Api::CurrentLogin::Create
  macro included
    skip :require_logged_in

    # post "/login" do
    #   run_operation
    # end

    def run_operation
      StartCurrentLogin.create(
        params,
        remote_ip: remote_ip?,
        session: nil
      ) do |operation, login|
        if operation.saved?
          do_run_operation_succeeded(operation, login.not_nil!)
        else
          response.status_code = 403
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, login)
      json({
        status: "success",
        message: Rex.t(:"action.current_login.create.success"),
        data: {
          login: LoginSerializer.new(login),
          token: BearerToken.new(operation, login),
          user: UserSerializer.new(login.user!)
        }
      })
    end

    def do_run_operation_failed(operation)
      json({
        status: "failure",
        message: Rex.t(:"action.current_login.create.failure"),
        data: {errors: operation.errors}
      })
    end
  end
end
