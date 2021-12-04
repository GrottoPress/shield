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

    getter user : User do
      UserQuery.find(user_id)
    end

    def do_run_operation_succeeded(operation, user)
      flash.success = Rex.t(:"action.user.destroy.success")
      redirect to: Index
    end

    def do_run_operation_failed(operation)
      flash.failure = Rex.t(:"action.user.destroy.failure")
      redirect_back fallback: Index
    end
  end
end
