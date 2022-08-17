module Shield::Api::Users::OauthAccessTokens::Destroy
  macro included
    skip :require_logged_out

    # delete "/users/:user_id/oauth/tokens" do
    #   run_operation
    # end

    getter user : User do
      UserQuery.find(user_id)
    end

    def run_operation
      RevokeUserOauthAccessTokens.update(user) do |operation, updated_user|
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
  end
end
