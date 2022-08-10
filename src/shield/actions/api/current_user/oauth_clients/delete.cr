module Shield::Api::CurrentUser::OauthClients::Delete
  macro included
    include Shield::Api::CurrentUser::OauthClients::Destroy

    # delete "/account/oauth/clients" do
    #   run_operation
    # end

    def run_operation
      DeleteCurrentUserOauthClients.update(user) do |operation, updated_user|
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
