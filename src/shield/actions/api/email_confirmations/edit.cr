module Shield::Api::EmailConfirmations::Edit
  # IMPORTANT!
  #
  # This requires the user to be logged in to update their email address.
  # The current user's ID is compared with the `user_id` retrieved from session
  # to ensure they match, before updating the email.
  #
  # This prevents problems when an existing user mistypes their new email
  # address, and the confirmation link gets sent to this wrong address.
  #
  # The new email address owner could click to confirm the email,
  # thus changing the user's email address to theirs. After that, they could
  # request for a password reset, locking the legitimate user out of their
  # account.
  macro included
    skip :require_logged_out

    before :pin_email_confirmation_to_ip_address

    # get "/email-confirmations/edit" do
    #   run_operation
    # end

    def run_operation
      EmailConfirmationParams.new(
        params
      ).verify do |utility, email_confirmation|
        if email_confirmation.try &.user_id == user.id # <= IMPORTANT!
          update_email(email_confirmation.not_nil!)
        else
          response.status_code = 403
          do_verify_operation_failed(utility)
        end
      end
    end

    def user
      current_or_bearer_user!
    end

    def do_verify_operation_failed(utility)
      json({status: "failure", message: "Invalid token"})
    end

    private def update_email(email_confirmation)
      UpdateConfirmedEmail.update(
        email_confirmation.user!.not_nil!,
        email_confirmation: email_confirmation
      ) do |operation, updated_user|
        if operation.saved?
          do_run_operation_succeeded(operation, updated_user)
        else
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, user)
      json({
        status: "success",
        message: "Email changed successfully",
        data: {user: UserSerializer.new(user)}
      })
    end

    def do_run_operation_failed(operation)
      json({
        status: "failure",
        message: "Could not change email",
        data: {errors: operation.errors}
      })
    end

    def authorize?(user : User) : Bool
      user.id == current_or_bearer_user.try &.id
    end
  end
end
