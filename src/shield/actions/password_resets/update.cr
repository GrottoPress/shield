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
          response.status_code = 403
          do_verify_operation_failed(utility)
        end
      end
    end

    def do_verify_operation_failed(utility)
      flash.failure = "Invalid token"
      redirect to: New
    end

    private def reset_password(password_reset)
      ResetPassword.update(
        password_reset.user,
        params,
        session: session,
        current_login: current_login?
      ) do |operation, updated_user|
        if operation.saved?
          do_run_operation_succeeded(operation, updated_user)
        else
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, user)
      flash.success = "Password changed successfully"
      redirect to: CurrentLogin::New
    end

    def do_run_operation_failed(operation)
      flash.failure = "Could not change password"
      html EditPage, operation: operation
    end
  end
end
