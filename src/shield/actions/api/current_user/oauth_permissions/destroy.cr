module Shield::Api::CurrentUser::OauthPermissions::Destroy
  macro included
    skip :require_logged_out

    # delete "/account/oauth/permissions/:oauth_client_id" do
    #   run_operation
    # end

    def user : User
      current_user
    end

    getter oauth_client : OauthClient do
      OauthClientQuery.find(oauth_client_id)
    end

    def run_operation
      RevokeOauthPermission.update(
        oauth_client,
        user: user
      ) do |operation, updated_oauth_client|
        if operation.saved?
          do_run_operation_succeeded(operation, updated_oauth_client)
        else
          response.status_code = 400
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, oauth_client)
      json OauthClientSerializer.new(
        oauth_client: oauth_client,
        user: user,
        message: Rex.t(:"action.current_user.oauth_permission.destroy.success")
      )
    end

    def do_run_operation_failed(operation)
      json FailureSerializer.new(
        errors: operation.errors,
        message: Rex.t(:"action.current_user.oauth_permission.destroy.failure")
      )
    end

    def authorize?(user : Shield::User) : Bool
      user.id == self.user.id
    end
  end
end
