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
      json({
        status: "success",
        message: Rex.t(:"action.user.create.success"),
        data: {user: UserSerializer.new(user)}
      })
    end

    def do_run_operation_failed(operation)
      json({
        status: "failure",
        message: Rex.t(:"action.user.create.failure"),
        data: {errors: operation.errors}
      })
    end
  end
end
