module Shield::OauthClients::Secret::Update
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
          OauthClientSession.new(session).set(operation, updated_oauth_client)
          do_run_operation_succeeded(operation, updated_oauth_client)
        else
          response.status_code = 400
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, oauth_client)
      flash.success = Rex.t(:"action.oauth_client.secret.update.success")
      redirect to: Show
    end

    def do_run_operation_failed(operation)
      flash.failure = Rex.t(:"action.oauth_client.secret.update.failure")

      redirect_back fallback: OauthClients::Show.with(
        oauth_client_id: oauth_client_id
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
