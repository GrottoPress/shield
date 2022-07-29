module Shield::Api::EmailConfirmations::Create
  # IMPORTANT!
  #
  # Prevent user enumeration by showing the same response
  # even if the email address is already registered.
  macro included
    skip :require_logged_in

    # post "/email-confirmations" do
    #   run_operation
    # end

    def run_operation
      StartEmailConfirmation.create(
        params,
        remote_ip: remote_ip?
      ) do |operation, email_confirmation|
        if operation.saved?
          do_run_operation_succeeded(operation, email_confirmation.not_nil!)
        else
          response.status_code = 400 unless operation.user_email?
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, email_confirmation)
      if LuckyEnv.production?
        success_action(operation)
      else
        json EmailConfirmationSerializer.new(
          email_confirmation: email_confirmation,
          token: EmailConfirmationCredentials.new(
            operation,
            email_confirmation
          ).to_s,
          message: Rex.t(:"action.misc.dev_mode_skip_email")
        )
      end
    end

    def do_run_operation_failed(operation)
      if operation.user_email?
        success_action(operation) # <= IMPORTANT!
      else
        failure_action(operation)
      end
    end

    private def success_action(operation)
      json EmailConfirmationSerializer.new(
        message: Rex.t(:"action.email_confirmation.create.success")
      )
    end

    private def failure_action(operation)
      json FailureSerializer.new(
        errors: operation.errors,
        message: Rex.t(:"action.email_confirmation.create.failure")
      )
    end
  end
end
