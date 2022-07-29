module Shield::PasswordResets::Create
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
        flash.success = Rex.t(:"action.misc.dev_mode_skip_email")
        redirect to: PasswordResetCredentials.new(operation, password_reset).url
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
      flash.success = Rex.t(:"action.password_reset.create.success")
      redirect to: CurrentLogin::New
    end

    private def failure_action(operation)
      flash.failure = Rex.t(:"action.password_reset.create.failure")
      html NewPage, operation: operation
    end
  end
end
