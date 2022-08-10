module Shield::Users::OauthClients::Destroy
  macro included
    skip :require_logged_out

    # delete "/users/:user_id/oauth/clients" do
    #   run_operation
    # end

    def run_operation
      DeactivateUserOauthClients.update(user) do |operation, updated_user|
        if operation.saved?
          do_run_operation_succeeded(operation, updated_user)
        else
          response.status_code = 400
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, user)
      flash.success = Rex.t(:"action.user.oauth_client.destroy.success")
      redirect to: Index.with(user_id: user_id)
    end

    def do_run_operation_failed(operation)
      flash.failure = Rex.t(:"action.user.oauth_client.destroy.failure")
      redirect_back fallback: Index.with(user_id: user_id)
    end

    getter user : User do
      UserQuery.find(user_id)
    end
  end
end
