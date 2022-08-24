module Shield::Api::CurrentUser::OauthClients::Create
  macro included
    skip :require_logged_out

    # post "/account/oauth/clients" do
    #   run_operation
    # end

    def run_operation
      RegisterOauthClient.create(
        params,
        user: user
      ) do |operation, oauth_client|
        if operation.saved?
          do_run_operation_succeeded(operation, oauth_client.not_nil!)
        else
          response.status_code = 400
          do_run_operation_failed(operation)
        end
      end
    end

    def user
      current_user_or_bearer
    end

    def do_run_operation_succeeded(operation, oauth_client)
      json OauthClientSerializer.new(
        oauth_client: oauth_client,
        secret: operation.secret,
        message: Rex.t(:"action.current_user.oauth_client.create.success")
      )
    end

    def do_run_operation_failed(operation)
      json FailureSerializer.new(
        errors: operation.errors,
        message: Rex.t(:"action.current_user.oauth_client.create.failure")
      )
    end

    def authorize?(user : Shield::User) : Bool
      user.id == self.user.id
    end
  end
end
