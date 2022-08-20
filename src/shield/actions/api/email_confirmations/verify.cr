module Shield::Api::EmailConfirmations::Verify
  macro included
    skip :require_logged_in
    skip :require_logged_out

    before :pin_email_confirmation_to_ip_address

    # post "/email-confirmations/verify" do
    #   run_operation
    # end

    def run_operation
      EmailConfirmationParams.new(
        params
      ).verify do |utility, email_confirmation|
        if email_confirmation
          do_verify_operation_succeeded(utility, email_confirmation.not_nil!)
        else
          response.status_code = 403
          do_verify_operation_failed(utility)
        end
      end
    end

    def do_verify_operation_succeeded(utility, email_confirmation)
      json EmailConfirmationSerializer.new(
        email_confirmation: email_confirmation,
        message: Rex.t(:"action.email_confirmation.verify.success")
      )
    end

    def do_verify_operation_failed(utility)
      json FailureSerializer.new(message: Rex.t(:"action.misc.token_invalid"))
    end

    def authorize?(user : User) : Bool
      user.id == current_user_or_bearer?.try(&.id)
    end
  end
end
