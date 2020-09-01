module Shield::EmailConfirmationCurrentUser::Create
  macro included
    include Shield::CurrentUser::Create

    before :pin_email_confirmation_to_ip_address

    # post "/register" do
    #   run_operation
    # end

    def run_operation
      EmailConfirmationSession.new(
        session
      ).verify do |utility, email_confirmation|
        if email_confirmation
          register_user(email_confirmation.not_nil!)
        else
          New.new(
            context,
            Hash(String, String).new
          ).do_run_operation_failed(utility)
        end
      end
    end

    private def register_user(email_confirmation)
      RegisterCurrentUser.create(
        params,
        email: email_confirmation.email,
        session: session,
      ) do |operation, user|
        if user
          do_run_operation_succeeded(operation, user.not_nil!)
        else
          do_run_operation_failed(operation)
        end
      end
    end
  end
end
