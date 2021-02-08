module Shield::EmailConfirmations::Create
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
        remote_ip: remote_ip
      ) do |operation, email_confirmation|
        if email_confirmation
          do_run_operation_succeeded(operation, email_confirmation.not_nil!)
        else
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, email_confirmation)
      if Lucky::Env.production?
        success_action(operation)
      else
        flash.success = "Development mode: No need to check your mail."
        redirect to: EmailConfirmationUrl.new(operation, email_confirmation)
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
      flash.success = "Done! Check your email for further instructions."
      redirect to: CurrentLogin::New
    end

    private def failure_action(operation)
      flash.failure = "Email confirmation request failed"
      html NewPage, operation: operation
    end
  end
end
