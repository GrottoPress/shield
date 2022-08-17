module Shield::Api::OauthPermissions::Destroy
  macro included
    skip :require_logged_out

    # delete "/oauth/clients/:oauth_client_id/users/:user_id" do
    #   run_operation
    # end

    getter user : User do # Resource owner
      UserQuery.find(user_id)
    end

    getter oauth_client : OauthClient do
      OauthClientQuery.find(oauth_client_id)
    end

    def run_operation
      RevokeOauthPermission.update(
        user,
        oauth_client: oauth_client
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
        oauth_client: oauth_client,
        message: Rex.t(:"action.oauth_permission.destroy.success")
      )
    end

    def do_run_operation_failed(operation)
      json FailureSerializer.new(
        errors: operation.errors,
        message: Rex.t(:"action.oauth_permission.destroy.failure")
      )
    end

    def authorize?(user : Shield::User) : Bool
      super || user.id.in?({oauth_client.user_id, self.user.id})
    end
  end
end
