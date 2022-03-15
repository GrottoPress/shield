module Shield::Api::Users::Create
  macro included
    skip :require_logged_out

    # post "/users" do
    #   run_operation
    # end

    def run_operation
      RegisterUser.create(params) do |operation, user|
        if operation.saved?
          do_run_operation_succeeded(operation, user.not_nil!)
        else
          response.status_code = 400
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, user)
      json UserSerializer.new(
        user: user,
        message: Rex.t(:"action.user.create.success")
      )
    end

    def do_run_operation_failed(operation)
      json FailureSerializer.new(
        errors: operation.errors,
        message: Rex.t(:"action.user.create.failure")
      )
    end
  end
end
