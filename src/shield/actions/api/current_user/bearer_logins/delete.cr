module Shield::Api::CurrentUser::BearerLogins::Delete
  macro included
    include Shield::Api::CurrentUser::BearerLogins::Destroy

    # delete "/account/bearer-logins" do
    #   run_operation
    # end

    def run_operation
      DeleteCurrentUserBearerLogins.update(
        user,
        current_bearer_login: current_bearer_login?
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
