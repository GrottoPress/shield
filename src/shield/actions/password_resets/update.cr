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
      flash.failure = Rex.t(:"action.misc.token_invalid")
      redirect to: New
    end

    private def reset_password(password_reset)
      ResetPassword.update(
        password_reset,
        params,
        session: session,
        current_login: current_login?
      ) do |operation, updated_password_reset|
        if operation.saved?
          do_run_operation_succeeded(operation, updated_password_reset)
        else
          response.status_code = 400
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, password_reset)
      flash.success = Rex.t(:"action.password_reset.update.success")
      redirect to: CurrentLogin::New
    end

    def do_run_operation_failed(operation)
      flash.failure = Rex.t(:"action.password_reset.update.failure")
      html EditPage, operation: operation
    end
  end
end
