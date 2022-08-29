module Shield::Api::OauthGrants::Destroy
  macro included
    skip :require_logged_out

    # delete "/oauth/grants/:oauth_grant_id" do
    #   run_operation
    # end

    def run_operation
      EndOauthGrant.update(oauth_grant) do |operation, updated_oauth_grant|
        if operation.saved?
          do_run_operation_succeeded(operation, updated_oauth_grant)
        else
          response.status_code = 400
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, oauth_grant)
      json OauthGrantSerializer.new(
        oauth_grant: oauth_grant,
        message: Rex.t(:"action.oauth_grant.destroy.success")
      )
    end

    def do_run_operation_failed(operation)
      json FailureSerializer.new(
        errors: operation.errors,
        message: Rex.t(:"action.oauth_grant.destroy.failure")
      )
    end

    getter oauth_grant : OauthGrant do
      OauthGrantQuery.find(oauth_grant_id)
    end

    def authorize?(user : Shield::User) : Bool
      super || user.id == oauth_grant.user_id
    end
  end
end
