module Shield::Users::Destroy
  macro included
    skip :require_logged_out

    # delete "/users/:user_id" do
    #   run_operation
    # end

    def run_operation
      DeleteUser.submit(
        params,
        current_user: current_user
      ) do |operation, deleted_user|
        if deleted_user
          do_run_operation_succeeded(operation, deleted_user.not_nil!)
        else
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, user)
      flash.keep
      flash.success = "User deleted successfully"
      redirect to: Index
    end

    def do_run_operation_failed(operation)
      flash.keep
      flash.failure = "Could not delete user"
      redirect to: Index
    end
  end
end
