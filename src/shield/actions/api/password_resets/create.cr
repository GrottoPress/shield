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
        if password_reset
          do_run_operation_succeeded(operation, password_reset.not_nil!)
        else
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, password_reset)
      if Lucky::Env.production?
        success_action(operation)
      else
        json({
          status: "success",
          message: "Development mode: No need to check your mail.",
          data: {token: BearerToken.new(operation, password_reset)}
        })
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
      json({
        status: "success",
        message: "Done! Check your email for further instructions."
      })
    end

    private def failure_action(operation)
      json({
        status: "failure",
        message: "Password reset request failed",
        data: {errors: operation.errors}
      })
    end
  end
end
