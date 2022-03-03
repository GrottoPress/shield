module Shield::Users::EmailConfirmations::Delete
  macro included
    include Shield::Users::EmailConfirmations::Destroy

    # delete "/users/:user_id/email-confirmations" do
    #   run_operation
    # end

    def run_operation
      DeleteUserEmailConfirmations.update(user) do |operation, updated_user|
        if operation.saved?
          do_run_operation_succeeded(operation, updated_user)
        else
          do_run_operation_failed(operation)
        end
      end
    end
  end
end
