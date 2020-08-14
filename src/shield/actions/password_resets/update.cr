module Shield::PasswordResets::Update
  macro included
    skip :require_logged_in

    before :pin_password_reset_to_ip_address

    # patch "/password-resets" do
    #   run_operation
    # end

    def run_operation
      PasswordResetSession.new(session).verify do |utility, password_reset|
        if password_reset
          reset_password(password_reset.not_nil!)
        else
          Edit.new(
            context,
            Hash(String, String).new
          ).do_run_operation_failed(utility)
        end
      end
    end

    private def reset_password(password_reset)
      ResetPassword.update(
        password_reset.user!,
        params,
        session: session,
        current_login: current_login
      ) do |operation, updated_user|
        if operation.saved?
          do_run_operation_succeeded(operation, updated_user)
        else
          do_run_operation_failed(operation, updated_user)
        end
      end
    end

    def do_run_operation_succeeded(operation, user)
      flash.success = "Password changed successfully"
      redirect to: Logins::New
    end

    def do_run_operation_failed(operation, user)
      flash.failure = "Could not change password"
      html EditPage, operation: operation, user: user
    end
  end
end
