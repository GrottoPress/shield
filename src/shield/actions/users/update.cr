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
        current_login: current_login?
      ) do |operation, updated_user|
        if operation.saved?
          do_run_operation_succeeded(operation, updated_user)
        else
          response.status_code = 400
          do_run_operation_failed(operation)
        end
      end
    end

    getter user : User do
      UserQuery.find(user_id)
    end

    def do_run_operation_succeeded(operation, user)
      flash.success = Rex.t(:"action.user.update.success")
      redirect to: Show.with(user_id: user.id)
    end

    def do_run_operation_failed(operation)
      flash.failure = Rex.t(:"action.user.update.failure")
      html EditPage, operation: operation
    end
  end
end
