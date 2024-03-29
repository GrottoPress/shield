module Shield::Api::OauthClients::Destroy
  macro included
    skip :require_logged_out

    # delete "/oauth/clients/:oauth_client_id" do
    #   run_operation
    # end

    def run_operation
      DeactivateOauthClient.update(
        oauth_client
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
        message: Rex.t(:"action.oauth_client.destroy.success")
      )
    end

    def do_run_operation_failed(operation)
      json FailureSerializer.new(
        errors: operation.errors,
        message: Rex.t(:"action.oauth_client.destroy.failure")
      )
    end

    getter oauth_client : OauthClient do
      OauthClientQuery.find(oauth_client_id)
    end

    def authorize?(user : Shield::User) : Bool
      super || user.id == oauth_client.user_id
    end
  end
end
