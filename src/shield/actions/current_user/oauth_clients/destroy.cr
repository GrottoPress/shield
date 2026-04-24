module Shield::CurrentUser::OauthClients::Destroy
  macro included
    skip :require_logged_out

    authorize_user do |user|
      user.id == self.user.id
    end

    # delete "/account/oauth/clients" do
    #   run_operation
    # end

    def run_operation
      DeactivateCurrentUserOauthClients.update(
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
      flash.success = Rex.t(:"action.current_user.oauth_client.destroy.success")
      redirect to: Index
    end

    def do_run_operation_failed(operation)
      flash.failure = Rex.t(:"action.current_user.oauth_client.destroy.failure")
      redirect_back fallback: Index
    end

    def user
      current_user
    end
  end
end
