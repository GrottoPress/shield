module Shield::Api::EmailConfirmations::Destroy
  macro included
    skip :require_logged_out

    # delete "/email-confirmations/:email_confirmation_id" do
    #   run_operation
    # end

    def run_operation
      EndEmailConfirmation.update(
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
      json({
        status: "success",
        message: Rex.t(:"action.email_confirmation.destroy.success"),
        data: {email_confirmation: EmailConfirmationSerializer.new(
          email_confirmation
        )}
      })
    end

    def do_run_operation_failed(operation)
      json({
        status: "failure",
        message: Rex.t(:"action.email_confirmation.destroy.failure"),
        data: {errors: operation.errors}
      })
    end

    getter email_confirmation : EmailConfirmation do
      EmailConfirmationQuery.find(email_confirmation_id)
    end

    def authorize?(user : Shield::User) : Bool
      super || user.id == email_confirmation.user_id
    end
  end
end
