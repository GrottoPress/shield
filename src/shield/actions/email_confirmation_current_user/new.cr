module Shield::EmailConfirmationCurrentUser::New
  macro included
    include Shield::CurrentUser::New

    before :pin_email_confirmation_to_ip_address

    # get "/register" do
    #   run_operation
    # end

    def run_operation
      EmailConfirmationSession.new(
        session
      ).verify do |utility, email_confirmation|
        if email_confirmation
          do_run_operation_succeeded(utility, email_confirmation.not_nil!)
        else
          do_run_operation_failed(utility)
        end
      end
    end

    def do_run_operation_succeeded(utility, email_confirmation)
      html NewPage, email: email_confirmation.email
    end

    def do_run_operation_failed(utility)
      flash.failure = "Invalid token"
      redirect to: EmailConfirmations::New
    end
  end
end
