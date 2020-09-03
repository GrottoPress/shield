module Shield::EmailConfirmationCurrentUser::Update
  macro included
    include Shield::CurrentUser::Update

    # patch "/account" do
    #   run_operation
    # end

    def run_operation
      UpdateCurrentUser.update(
        user,
        params,
        current_login: current_login,
        remote_ip: remote_ip
      ) do |operation, updated_user|
        if operation.saved?
          do_run_operation_succeeded(operation, updated_user)
        else
          do_run_operation_failed(operation, updated_user)
        end
      end
    end

    def do_run_operation_succeeded(operation, user)
      if operation.new_email
        flash.success = "Account updated successfully. Check '#{
          operation.new_email}' for further instructions."
      else
        flash.success = "Account updated successfully"
      end

      redirect to: Show
    end
  end
end
