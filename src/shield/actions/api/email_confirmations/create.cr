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
      success_action(operation)
    end

    def do_run_operation_failed(operation)
      if operation.user_email?
        success_action(operation) # <= IMPORTANT!
      else
        json({
          status: "failure",
          message: "Email confirmation request failed",
          data: {errors: operation.errors}
        })
      end
    end

    private def success_action(operation)
      json({
        status: "success",
        message: "Done! Check your email for further instructions."
      })
    end
  end
end
