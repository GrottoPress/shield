module Shield::Api::PasswordResets::Destroy
  macro included
    skip :require_logged_out

    # delete "/password-resets/:password_reset_id" do
    #   run_operation
    # end

    def run_operation
      EndPasswordReset.update(
        password_reset,
        session: nil
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
        message: Rex.t(:"action.password_reset.destroy.success")
      )
    end

    def do_run_operation_failed(operation)
      json FailureSerializer.new(
        errors: operation.errors,
        message: Rex.t(:"action.password_reset.destroy.failure")
      )
    end

    getter password_reset : PasswordReset do
      PasswordResetQuery.find(password_reset_id)
    end

    def authorize?(user : Shield::User) : Bool
      super || user.id == password_reset.user_id
    end
  end
end
