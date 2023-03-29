module Shield::Api::BearerLogins::Delete
  macro included
    include Shield::Api::BearerLogins::Destroy

    # delete "/bearer-logins/:bearer_login_id" do
    #   run_operation
    # end

    def run_operation
      DeleteBearerLogin.delete(
        bearer_login
      ) do |operation, deleted_bearer_login|
        if operation.deleted?
          do_run_operation_succeeded(operation, deleted_bearer_login)
        else
          response.status_code = 400
          do_run_operation_failed(operation)
        end
      end
    end
  end
end
