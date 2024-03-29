module Shield::PasswordResets::Edit
  macro included
    skip :require_logged_in

    before :pin_password_reset_to_ip_address

    # get "/password-resets/edit" do
    #   run_operation
    # end

    def run_operation
      PasswordResetSession.new(session).verify do |utility, password_reset|
        if password_reset
          render_form(utility, password_reset.not_nil!)
        else
          response.status_code = 403
          do_verify_operation_failed(utility)
        end
      end
    end

    private def render_form(utility, password_reset)
      operation = ResetPassword.new(
        password_reset,
        session: session,
        current_login: current_login?
      )

      html EditPage, operation: operation
    end

    def do_verify_operation_failed(utility)
      flash.failure = Rex.t(:"action.misc.token_invalid")
      redirect to: New
    end
  end
end
