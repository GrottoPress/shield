module Shield::PasswordResets::Delete
  macro included
    include Shield::PasswordResets::Destroy

    # delete "/password-resets/:password_reset_id" do
    #   run_operation
    # end

    def run_operation
      DeletePasswordReset.delete(
        password_reset,
        session: session
      ) do |operation, deleted_password_reset|
        if operation.deleted?
          do_run_operation_succeeded(operation, deleted_password_reset)
        else
          response.status_code = 400
          do_run_operation_failed(operation)
        end
      end
    end
  end
end
