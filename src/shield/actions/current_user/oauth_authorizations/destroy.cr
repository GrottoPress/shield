module Shield::CurrentUser::OauthAuthorizations::Destroy
  macro included
    skip :require_logged_out

    # delete "/account/oauth/authorizations" do
    #   run_operation
    # end

    def user
      current_user
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
      flash.success =
        Rex.t(:"action.current_user.oauth_authorization.destroy.success")

      redirect to: Index
    end

    def do_run_operation_failed(operation)
      flash.failure =
        Rex.t(:"action.current_user.oauth_authorization.destroy.failure")

      redirect_back fallback: Index
    end

    def authorize?(user : Shield::User) : Bool
      user.id == self.user.id
    end
  end
end
