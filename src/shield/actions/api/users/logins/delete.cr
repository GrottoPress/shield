module Shield::Api::Users::Logins::Delete
  macro included
    include Shield::Api::Users::Logins::Destroy

    # delete "/users/:user_id/logins" do
    #   run_operation
    # end

    def run_operation
      DeleteUserLogins.update(
        user,
        current_login: current_login?
      ) do |operation, updated_user|
        if operation.saved?
          do_run_operation_succeeded(operation, updated_user)
        else
          do_run_operation_failed(operation)
        end
      end
    end
  end
end
