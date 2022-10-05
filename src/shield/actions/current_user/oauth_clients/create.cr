module Shield::CurrentUser::OauthClients::Create
  macro included
    skip :require_logged_out

    # post "/account/oauth/clients" do
    #   run_operation
    # end

    def run_operation
      RegisterOauthClient.create(
        params,
        redirect_uris: redirect_uris_from_params,
        user: user
      ) do |operation, oauth_client|
        if operation.saved?
          OauthClientSession.new(session).set(operation, oauth_client.not_nil!)
          do_run_operation_succeeded(operation, oauth_client.not_nil!)
        else
          response.status_code = 400
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, oauth_client)
      flash.success = Rex.t(:"action.current_user.oauth_client.create.success")
      redirect to: ::OauthClients::Secret::Show
    end

    def do_run_operation_failed(operation)
      flash.failure = Rex.t(:"action.current_user.oauth_client.create.failure")
      html NewPage, operation: operation
    end

    def user
      current_user
    end

    def authorize?(user : Shield::User) : Bool
      user.id == self.user.id
    end

    private def redirect_uris_from_params
      array_param(RegisterOauthClient.param_key, :redirect_uris)
    end
  end
end
