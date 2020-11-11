module Shield::Api::Users::Create
  macro included
    skip :require_logged_out

    # post "/users" do
    #   run_operation
    # end

    def run_operation
      RegisterUser.create(params) do |operation, user|
        if user
          do_run_operation_succeeded(operation, user.not_nil!)
        else
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, user)
      json({
        status: "success",
        message: "User added successfully",
        data: {user: UserSerializer.new(user)}
      })
    end

    def do_run_operation_failed(operation)
      json({
        status: "failure",
        message: "Could not add user",
        data: {errors: operation.errors}
      })
    end
  end
end
