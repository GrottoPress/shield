module Shield::CurrentUser::Logins::Delete
  macro included
    include Shield::CurrentUser::Logins::Destroy

    # delete "/account/logins" do
    #   run_operation
    # end

    def run_operation
      DeleteCurrentUserLogins.update(
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
