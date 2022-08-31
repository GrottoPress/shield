module Shield::Api::OauthPermissions::Delete
  macro included
    include Shield::Api::OauthPermissions::Destroy

    # delete "/oauth/clients/:oauth_client_id/users/:user_id" do
    #   run_operation
    # end

    def run_operation
      DeleteOauthPermission.update(
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
  end
end
