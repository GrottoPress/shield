module Shield::Users::Update
  macro included
    skip :require_logged_out

    # patch "/users/:user_id" do
    #   run_operation
    # end

    def run_operation
      UpdateUser.update(
        user,
        params,
        current_login: current_login
      ) do |operation, updated_user|
        if operation.saved?
          do_run_operation_succeeded(operation, updated_user)
        else
          do_run_operation_failed(operation)
        end
      end
    end

    getter user : User do
      UserQuery.find(user_id)
    end

    def do_run_operation_succeeded(operation, user)
      flash.success = "User updated successfully"
      redirect to: Show.with(user_id: user.id)
    end

    def do_run_operation_failed(operation)
      flash.failure = "Could not update user"
      html EditPage, operation: operation
    end
  end
end
