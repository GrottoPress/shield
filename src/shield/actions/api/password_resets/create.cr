module Shield::Api::PasswordResets::Create
  # IMPORTANT!
  #
  # Prevent user enumeration by showing the same response
  # even if the email address is not registered.
  #
  # REFERENCES:
  #
  # - https://www.troyhunt.com/everything-you-ever-wanted-to-know/
  macro included
    skip :require_logged_in

    # post "/password-resets" do
    #   run_operation
    # end

    def run_operation
      StartPasswordReset.create(
        params,
        remote_ip: remote_ip?
      ) do |operation, password_reset|
        if operation.saved?
          do_run_operation_succeeded(operation, password_reset.not_nil!)
        else
          response.status_code = 400 unless operation.guest_email?
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, password_reset)
      if LuckyEnv.production?
        success_action(operation)
      else
        json PasswordResetSerializer.new(
          password_reset: password_reset,
          token: PasswordResetCredentials.new(operation, password_reset).to_s,
          message: Rex.t(:"action.misc.dev_mode_skip_email")
        )
      end
    end

    def do_run_operation_failed(operation)
      if operation.guest_email?
        success_action(operation) # <= IMPORTANT!
      else
        failure_action(operation)
      end
    end

    private def success_action(operation)
      json PasswordResetSerializer.new(
        message: Rex.t(:"action.password_reset.create.success")
      )
    end

    private def failure_action(operation)
      json FailureSerializer.new(
        errors: operation.errors,
        message: Rex.t(:"action.password_reset.create.failure")
      )
    end
  end
end
