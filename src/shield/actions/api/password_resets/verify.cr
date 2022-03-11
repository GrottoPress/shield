module Shield::Api::PasswordResets::Verify
  macro included
    skip :require_logged_in

    before :pin_password_reset_to_ip_address

    # post "/password-resets/verify" do
    #   run_operation
    # end

    def run_operation
      PasswordResetParams.new(params).verify do |utility, password_reset|
        if password_reset
          do_verify_operation_succeeded(utility, password_reset.not_nil!)
        else
          response.status_code = 403
          do_verify_operation_failed(utility)
        end
      end
    end

    def do_verify_operation_succeeded(utility, password_reset)
      json ItemResponse.new(
        password_reset: password_reset,
        message: Rex.t(:"action.password_reset.verify.success")
      )
    end

    def do_verify_operation_failed(utility)
      json FailureResponse.new(message: Rex.t(:"action.misc.token_invalid"))
    end
  end
end
