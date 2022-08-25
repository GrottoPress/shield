module Shield::Api::OauthClients::Secret::Update
  macro included
    skip :require_logged_out

    # patch "/oauth/clients/:oauth_client_id/secret" do
    #   run_operation
    # end

    def run_operation
      RotateOauthClientSecret.update(
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
        secret: operation.secret,
        message: Rex.t(:"action.oauth_client.secret.update.success")
      )
    end

    def do_run_operation_failed(operation)
      json FailureSerializer.new(
        errors: operation.errors,
        message: Rex.t(:"action.oauth_client.secret.update.failure")
      )
    end

    getter oauth_client : OauthClient do
      OauthClientQuery.find(oauth_client_id)
    end

    def authorize?(user : Shield::User) : Bool
      user.id == oauth_client.user_id
    end
  end
end
