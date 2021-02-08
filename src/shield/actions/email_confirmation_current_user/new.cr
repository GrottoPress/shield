module Shield::EmailConfirmationCurrentUser::New
  macro included
    include Shield::CurrentUser::New

    before :pin_email_confirmation_to_ip_address

    # get "/account/new" do
    #   run_operation
    # end

    def run_operation
      EmailConfirmationSession.new(
        session
      ).verify do |utility, email_confirmation|
        if email_confirmation
          render_form(utility, email_confirmation.not_nil!)
        else
          response.status_code = 403
          do_verify_operation_failed(utility)
        end
      end
    end

    private def render_form(utility, email_confirmation)
      operation = RegisterCurrentUser.new(
        email: email_confirmation.email,
        email_confirmation: email_confirmation,
        session: session
      );

      html NewPage, operation: operation
    end

    def do_verify_operation_failed(utility)
      flash.failure = "Invalid token"
      redirect to: EmailConfirmations::New
    end
  end
end
