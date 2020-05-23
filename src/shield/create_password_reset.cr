module Shield::CreatePasswordReset
  macro included
    skip :require_logged_in
    before :require_logged_out

    # post "/password-resets" do
    #   save_password_reset
    # end

    private def save_password_reset
      SavePasswordReset.create(
        params,
        ip_address: remote_ip
      ) do |operation, password_reset|
        if password_reset
          success_action(operation, password_reset.not_nil!)
        elsif operation.user_email.errors.empty? && operation.user_id.value.nil?
          email_not_found_action(operation)
        else
          failure_action(operation)
        end
      end
    end

    private def success_action(operation, password_reset)
      mail PasswordResetRequestEmail, operation, password_reset
      flash.success = "Done! Check your email for further instructions."
      redirect to: Logins::New
    end

    private def failure_action(operation)
      flash.failure = "Password reset request failed"
      html NewPage, operation: operation
    end

    private def email_not_found_action(operation)
      mail GuestPasswordResetRequestEmail, operation
      flash.success = "Done! Check your email for further instructions."
      redirect to: Logins::New
    end
  end
end
