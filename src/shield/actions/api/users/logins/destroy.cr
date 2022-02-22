module Shield::Api::Users::Logins::Destroy
  macro included
    skip :require_logged_out

    # delete "/users/:user_id/logins" do
    #   run_operation
    # end

    def run_operation
      EndUserLogins.update(
        user,
        current_login: current_login?
      ) do |operation, updated_user|
        if operation.saved?
          do_run_operation_succeeded(operation, updated_user)
        else
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, user)
      json({
        status: "success",
        message: Rex.t(:"action.user.login.destroy.success"),
        data: {user: UserSerializer.new(user)}
      })
    end

    def do_run_operation_failed(operation)
      json({
        status: "failure",
        message: Rex.t(:"action.user.login.destroy.failure"),
        data: {errors: operation.errors}
      })
    end

    getter user : User do
      UserQuery.find(user_id)
    end
  end
end
