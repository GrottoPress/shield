module Shield::Api::Users::BearerLogins::Destroy
  macro included
    skip :require_logged_out

    # delete "/users/:user_id/bearer-logins" do
    #   run_operation
    # end

    def run_operation
      RevokeUserBearerLogins.update(
        user,
        current_bearer_login: current_bearer_login?
      ) do |operation, updated_user|
        if operation.saved?
          do_run_operation_succeeded(operation, updated_user)
        else
          response.status_code = 400
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, user)
      json UserSerializer.new(
        user: user,
        message: Rex.t(:"action.user.bearer_login.destroy.success")
      )
    end

    def do_run_operation_failed(operation)
      json FailureSerializer.new(
        errors: operation.errors,
        message: Rex.t(:"action.user.bearer_login.destroy.failure")
      )
    end

    getter user : User do
      UserQuery.find(user_id)
    end
  end
end
