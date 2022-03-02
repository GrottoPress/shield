module Shield::Api::CurrentUser::PasswordResets::Delete
  macro included
    include Shield::Api::CurrentUser::PasswordResets::Destroy

    # delete "/account/password-resets" do
    #   run_operation
    # end

    def run_operation
      DeleteCurrentUserPasswordResets.update(user) do |operation, updated_user|
        if operation.saved?
          do_run_operation_succeeded(operation, updated_user)
        else
          do_run_operation_failed(operation)
        end
      end
    end
  end
end
