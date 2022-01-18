module Shield::Api::Users::Destroy
  macro included
    skip :require_logged_out

    # delete "/users/:user_id" do
    #   run_operation
    # end

    # def run_operation
    #   DeactivateUser.update(user) do |operation, updated_user|
    #     if operation.saved?
    #       do_run_operation_succeeded(operation, updated_user)
    #     else
    #       response.status_code = 400
    #       do_run_operation_failed(operation)
    #     end
    #   end
    # end

    getter user : User do
      UserQuery.find(user_id)
    end

    def do_run_operation_succeeded(operation, user)
      json({
        status: "success",
        message: Rex.t(:"action.user.destroy.success"),
        data: {user: UserSerializer.new(user)}
      })
    end

    def do_run_operation_failed(operation)
      json({
        status: "failure",
        message: Rex.t(:"action.user.destroy.failure"),
        data: {errors: operation.errors}
      })
    end
  end
end
