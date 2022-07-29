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
      json LoginSerializer.new(
        login: login,
        token: LoginCredentials.new(operation, login).to_s,
        message: Rex.t(:"action.current_login.create.success")
      )
    end

    def do_run_operation_failed(operation)
      json FailureSerializer.new(
        errors: operation.errors,
        message: Rex.t(:"action.current_login.create.failure")
      )
    end
  end
end
