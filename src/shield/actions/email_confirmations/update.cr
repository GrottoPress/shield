module Shield::EmailConfirmations::Update
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

    # get "/email-confirmations/update" do
    #   run_operation
    # end

    def run_operation
      EmailConfirmationSession.new(
        session
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
      current_user
    end

    def do_verify_operation_failed(utility)
      flash.failure = Rex.t(:"action.misc.token_invalid")
      redirect to: New
    end

    private def update_email(email_confirmation)
      UpdateConfirmedEmail.update(
        email_confirmation,
        session: session
      ) do |operation, updated_email_confirmation|
        if operation.saved?
          do_run_operation_succeeded(operation, updated_email_confirmation)
        else
          response.status_code = 400
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, email_confirmation)
      flash.success = Rex.t(:"action.email_confirmation.update.success")
      redirect to: CurrentUser::Show
    end

    def do_run_operation_failed(operation)
      flash.failure = Rex.t(:"action.email_confirmation.update.failure")
      redirect to: CurrentUser::Edit
    end

    def authorize?(user : Shield::User) : Bool
      user.id == self.user.id
    end
  end
end
