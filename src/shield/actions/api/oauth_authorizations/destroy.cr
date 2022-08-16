module Shield::Api::OauthAuthorizations::Destroy
  macro included
    skip :require_logged_out

    # delete "/oauth/authorizations/:oauth_authorization_id" do
    #   run_operation
    # end

    def run_operation
      EndOauthAuthorization.update(
        oauth_authorization
      ) do |operation, updated_oauth_authorization|
        if operation.saved?
          do_run_operation_succeeded(operation, updated_oauth_authorization)
        else
          response.status_code = 400
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, oauth_authorization)
      json OauthAuthorizationSerializer.new(
        oauth_authorization: oauth_authorization,
        message: Rex.t(:"action.oauth_authorization.destroy.success")
      )
    end

    def do_run_operation_failed(operation)
      json FailureSerializer.new(
        errors: operation.errors,
        message: Rex.t(:"action.oauth_authorization.destroy.failure")
      )
    end

    getter oauth_authorization : OauthAuthorization do
      OauthAuthorizationQuery.find(oauth_authorization_id)
    end

    def authorize?(user : Shield::User) : Bool
      super || user.id == oauth_authorization.user_id
    end
  end
end
