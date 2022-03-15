module Shield::Api::PasswordResets::Update
  macro included
    skip :require_logged_in

    before :pin_password_reset_to_ip_address

    # patch "/password-resets" do
    #   run_operation
    # end

    def run_operation
      PasswordResetParams.new(params).verify do |utility, password_reset|
        if password_reset
          reset_password(password_reset.not_nil!)
        else
          response.status_code = 403
          do_verify_operation_failed(utility)
        end
      end
    end

    def do_verify_operation_failed(utility)
      json FailureSerializer.new(message: Rex.t(:"action.misc.token_invalid"))
    end

    private def reset_password(password_reset)
      ResetPassword.update(
        password_reset,
        params,
        session: nil,
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
      json PasswordResetSerializer.new(
        password_reset: password_reset,
        message: Rex.t(:"action.password_reset.update.success")
      )
    end

    def do_run_operation_failed(operation)
      json FailureSerializer.new(
        errors: operation.errors,
        message: Rex.t(:"action.password_reset.update.failure")
      )
    end
  end
end
