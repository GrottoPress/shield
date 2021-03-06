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
    #       do_run_operation_failed(operation)
    #     end
    #   end
    # end

    @[Memoize]
    def user : User
      UserQuery.find(user_id)
    end

    def do_run_operation_succeeded(operation, user)
      json({
        status: "success",
        message: "User deleted successfully",
        data: {user: UserSerializer.new(user)}
      })
    end

    def do_run_operation_failed(operation)
      json({
        status: "failure",
        message: "Could not delete user",
        data: {errors: operation.errors}
      })
    end
  end
end
