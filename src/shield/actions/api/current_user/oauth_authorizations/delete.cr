module Shield::Api::CurrentUser::OauthAuthorizations::Delete
  macro included
    include Shield::Api::CurrentUser::OauthAuthorizations::Destroy

    # delete "/account/oauth/authorizations" do
    #   run_operation
    # end

    def run_operation
      DeleteCurrentUserOauthAuthorizations.update(
        user
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
