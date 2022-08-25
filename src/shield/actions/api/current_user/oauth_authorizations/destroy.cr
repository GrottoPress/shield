module Shield::Api::CurrentUser::OauthAuthorizations::Destroy
  macro included
    skip :require_logged_out

    # delete "/account/oauth/authorizations" do
    #   run_operation
    # end

    def user
      current_user_or_bearer
    end

    def run_operation
      EndCurrentUserOauthAuthorizations.update(
        user
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
        message: Rex.t(
          :"action.current_user.oauth_authorization.destroy.success"
        )
      )
    end

    def do_run_operation_failed(operation)
      json FailureSerializer.new(
        errors: operation.errors,
        message: Rex.t(
          :"action.current_user.oauth_authorization.destroy.failure"
        )
      )
    end

    def authorize?(user : Shield::User) : Bool
      user.id == self.user.id
    end
  end
end
