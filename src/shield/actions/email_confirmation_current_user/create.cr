module Shield::EmailConfirmationCurrentUser::Create
  macro included
    include Shield::CurrentUser::Create

    before :pin_email_confirmation_to_ip_address

    # post "/account" do
    #   run_operation
    # end

    def run_operation
      EmailConfirmationSession.new(
        session
      ).verify do |utility, email_confirmation|
        if email_confirmation
          register_user(email_confirmation.not_nil!)
        else
          response.status_code = 403
          do_verify_operation_failed(utility)
        end
      end
    end

    private def register_user(email_confirmation)
      RegisterCurrentUser.create(
        params,
        email_confirmation: email_confirmation,
        session: session,
      ) do |operation, user|
        if operation.saved?
          do_run_operation_succeeded(operation, user.not_nil!)
        else
          response.status_code = 400
          do_run_operation_failed(operation)
        end
      end
    end

    def do_verify_operation_failed(utility)
      flash.failure = Rex.t(:"action.misc.token_invalid")
      redirect to: ::EmailConfirmations::New
    end
  end
end
