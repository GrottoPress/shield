module Shield::CurrentUser::Update
  macro included
    skip :require_logged_out

    # patch "/profile" do
    #   run_operation
    # end

    def run_operation
      UpdateCurrentUser.update(
        user,
        params,
        current_login: current_login
      ) do |operation, updated_user|
        if operation.saved?
          do_run_operation_succeeded(operation, updated_user)
        else
          do_run_operation_failed(operation, updated_user)
        end
      end
    end

    def user
      current_user!
    end

    def do_run_operation_succeeded(operation, user)
      flash.success = "User updated successfully"
      redirect to: Show
    end

    def do_run_operation_failed(operation, user)
      flash.failure = "Could not update user"
      html EditPage, operation: operation, user: user
    end

    def authorize? : Bool
      true
    end
  end
end
