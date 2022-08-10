module Shield::Api::OauthClients::Delete
  macro included
    include Shield::Api::OauthClients::Destroy

    # delete "/oauth/clients/:oauth_client_id" do
    #   run_operation
    # end

    def run_operation
      DeleteOauthClient.delete(
        oauth_client
      ) do |operation, deleted_oauth_client|
        if operation.deleted?
          do_run_operation_succeeded(operation, deleted_oauth_client.not_nil!)
        else
          do_run_operation_failed(operation)
        end
      end
    end
  end
end
