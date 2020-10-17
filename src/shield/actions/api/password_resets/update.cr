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
      json({status: "failure", message: "Invalid token"})
    end

    private def reset_password(password_reset)
      ResetPassword.update(
        password_reset.user!,
        params,
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
      json({
        status: "success",
        message: "Password changed successfully",
        data: {user: UserSerializer.new(user)}
      })
    end

    def do_run_operation_failed(operation, user)
      json({
        status: "failure",
        message: "Could not change password",
        data: {errors: operation.errors}
      })
    end
  end
end
