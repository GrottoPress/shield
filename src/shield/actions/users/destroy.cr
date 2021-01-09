module Shield::Users::Destroy
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
      flash.keep.success = "User deleted successfully"
      redirect to: Index
    end

    def do_run_operation_failed(operation)
      flash.keep.failure = "Could not delete user"
      redirect_back fallback: Index
    end
  end
end
