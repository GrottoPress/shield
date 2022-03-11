module Shield::Api::EmailConfirmations::Update
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

    # patch "/email-confirmations" do
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

    {% if Avram::Model.all_subclasses
      .map(&.stringify)
      .includes?("BearerLogin") %}

      def user
        current_user_or_bearer
      end
    {% else %}
      def user
        current_user
      end
    {% end %}

    def do_verify_operation_failed(utility)
      json FailureResponse.new(message: Rex.t(:"action.misc.token_invalid"))
    end

    private def update_email(email_confirmation)
      UpdateConfirmedEmail.update(
        email_confirmation,
        session: nil
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
      json ItemResponse.new(
        email_confirmation: email_confirmation,
        user: user.reload,
        message: Rex.t(:"action.email_confirmation.update.success")
      )
    end

    def do_run_operation_failed(operation)
      json FailureResponse.new(
        errors: operation.errors,
        message: Rex.t(:"action.email_confirmation.update.failure")
      )
    end

    def authorize?(user : Shield::User) : Bool
      user.id == self.user.id
    end
  end
end
