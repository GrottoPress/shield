module Shield::OauthAuthorizations::Delete
  macro included
    include Shield::OauthAuthorizations::Destroy

    # delete "/oauth/authorizations/:oauth_authorization_id" do
    #   run_operation
    # end

    def run_operation
      DeleteOauthAuthorization.delete(
        oauth_authorization
      ) do |operation, deleted_oauth_authorization|
        if operation.deleted?
          do_run_operation_succeeded(
            operation,
            deleted_oauth_authorization.not_nil!
          )
        else
          response.status_code = 400
          do_run_operation_failed(operation)
        end
      end
    end
  end
end
