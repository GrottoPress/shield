module Shield::CurrentUser::EmailConfirmations::Delete
  macro included
    include Shield::CurrentUser::EmailConfirmations::Destroy

    # delete "/account/email-confirmations" do
    #   run_operation
    # end

    def run_operation
      DeleteCurrentUserEmailConfirmations.update(
        user
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
