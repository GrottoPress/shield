module Shield::Api::OauthPermissions::Delete
  macro included
    include Shield::Api::OauthPermissions::Destroy

    # delete "/oauth/clients/:oauth_client_id/users/:user_id" do
    #   run_operation
    # end

    def run_operation
      DeleteOauthPermission.update(
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
  end
end
