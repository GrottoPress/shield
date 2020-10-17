module Shield::Api::CurrentUser::Update
  macro included
    skip :require_logged_out

    # patch "/account" do
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
      current_or_bearer_user!
    end

    def do_run_operation_succeeded(operation, user)
      json({
        status: "success",
        message: "Account updated successfully",
        data: {user: UserSerializer.new(user)}
      })
    end

    def do_run_operation_failed(operation, user)
      json({
        status: "failure",
        message: "Could not update your account",
        data: {errors: operation.errors}
      })
    end

    def authorize?(user : User) : Bool
      user.id == current_or_bearer_user.try &.id
    end
  end
end
