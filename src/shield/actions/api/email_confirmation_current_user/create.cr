module Shield::Api::EmailConfirmationCurrentUser::Create
  # IMPORTANT!
  #
  # Prevent user enumeration by showing the same response
  # even if the email address is already registered.
  #
  # This assumes we're sending welcome emails.
  macro included
    include Shield::Api::CurrentUser::Create

    before :pin_email_confirmation_to_ip_address

    # post "/account" do
    #   run_operation
    # end

    def run_operation
      EmailConfirmationParams.new(
        params
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
        session: nil
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
      json FailureSerializer.new(message: Rex.t(:"action.misc.token_invalid"))
    end
  end
end
