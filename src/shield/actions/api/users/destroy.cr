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
      json ItemResponse.new(
        user: user,
        message: Rex.t(:"action.user.destroy.success")
      )
    end

    def do_run_operation_failed(operation)
      json FailureResponse.new(
        errors: operation.errors,
        message: Rex.t(:"action.user.destroy.failure")
      )
    end
  end
end
