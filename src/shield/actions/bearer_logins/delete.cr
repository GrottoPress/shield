module Shield::BearerLogins::Delete
  macro included
    include Shield::BearerLogins::Destroy

    # delete "/bearer-logins/:bearer_login_id" do
    #   run_operation
    # end

    def run_operation
      DeleteBearerLogin.destroy(
        bearer_login
      ) do |operation, deleted_bearer_login|
        if operation.deleted?
          do_run_operation_succeeded(operation, deleted_bearer_login.not_nil!)
        else
          do_run_operation_failed(operation)
        end
      end
    end
  end
end
