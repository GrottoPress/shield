module Shield::Users::PasswordResets::Delete
  macro included
    include Shield::Users::PasswordResets::Destroy

    # delete "/users/:user_id/password-resets" do
    #   run_operation
    # end

    def run_operation
      DeleteUserPasswordResets.update(user) do |operation, updated_user|
        if operation.saved?
          do_run_operation_succeeded(operation, updated_user)
        else
          do_run_operation_failed(operation)
        end
      end
    end
  end
end
