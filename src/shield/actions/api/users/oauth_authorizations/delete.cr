module Shield::Api::Users::OauthAuthorizations::Delete
  macro included
    include Shield::Api::Users::OauthAuthorizations::Destroy

    # delete "/users/:user_id/oauth/authorizations" do
    #   run_operation
    # end

    def run_operation
      DeleteUserOauthAuthorizations.update(user) do |operation, updated_user|
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
