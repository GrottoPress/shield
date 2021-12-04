module Shield::Api::Users::Update
  macro included
    skip :require_logged_out

    # patch "/users/:user_id" do
    #   run_operation
    # end

    def run_operation
      UpdateUser.update(
        user,
        params,
        current_login: current_login?
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
      json({
        status: "success",
        message: Rex.t(:"action.user.update.success"),
        data: {user: UserSerializer.new(user)}
      })
    end

    def do_run_operation_failed(operation)
      json({
        status: "failure",
        message: Rex.t(:"action.user.update.failure"),
        data: {errors: operation.errors}
      })
    end
  end
end
