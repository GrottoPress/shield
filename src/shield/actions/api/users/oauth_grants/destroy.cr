module Shield::Api::Users::OauthGrants::Destroy
  macro included
    skip :require_logged_out

    # delete "/users/:user_id/oauth/grants" do
    #   run_operation
    # end

    getter user : User do
      UserQuery.find(user_id)
    end

    def run_operation
      EndUserOauthGrants.update(user) do |operation, updated_user|
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
        message: Rex.t(:"action.user.oauth_grant.destroy.success")
      )
    end

    def do_run_operation_failed(operation)
      json FailureSerializer.new(
        errors: operation.errors,
        message: Rex.t(:"action.user.oauth_grant.destroy.failure")
      )
    end
  end
end
