module Shield::Api::CurrentLogin::Create
  macro included
    skip :require_logged_in

    # post "/login" do
    #   run_operation
    # end

    def run_operation
      LogUserIn.create(params, remote_ip: remote_ip) do |operation, login|
        if login
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
        message: "Copy the token now; it will only be shown once!"
        data: {
          login: LoginSerializer.new(login),
          token: LoginHelper.bearer_token(login, operation)
        }
      })
    end

    def do_run_operation_failed(operation)
      json({
        status: "failure",
        message: "Invalid email or password",
        data: {errors: operation.errors}
      })
    end
  end
end
