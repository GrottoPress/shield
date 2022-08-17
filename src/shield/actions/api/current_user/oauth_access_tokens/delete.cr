module Shield::Api::CurrentUser::OauthAccessTokens::Delete
  macro included
    include Shield::Api::CurrentUser::OauthAccessTokens::Destroy

    # delete "/account/oauth/tokens" do
    #   run_operation
    # end

    def run_operation
      DeleteCurrentUserOauthAccessTokens.update(
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
