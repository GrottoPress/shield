module Shield::Api::CurrentUser::OauthGrants::Delete
  macro included
    include Shield::Api::CurrentUser::OauthGrants::Destroy

    # delete "/account/oauth/grants" do
    #   run_operation
    # end

    def run_operation
      DeleteCurrentUserOauthGrants.update(user) do |operation, updated_user|
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
