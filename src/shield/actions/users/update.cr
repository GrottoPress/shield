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
          do_run_operation_failed(operation, updated_user)
        end
      end
    end

    @[Memoize]
    def user
      UserQuery.find(user_id)
    end

    def do_run_operation_succeeded(operation, user)
      flash.keep.success = "User updated successfully"
      redirect to: Show.with(user_id: user_id)
    end

    def do_run_operation_failed(operation, user)
      flash.failure = "Could not update user"
      html EditPage, operation: operation, user: user
    end
  end
end
