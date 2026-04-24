module Shield::EmailConfirmations::Destroy
  macro included
    skip :require_logged_out

    authorize_user do |user|
      super || user.id == email_confirmation.user_id
    end

    # delete "/email-confirmations/:email_confirmation_id" do
    #   run_operation
    # end

    def run_operation
      EndEmailConfirmation.update(
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
      flash.success = Rex.t(:"action.email_confirmation.destroy.success")
      redirect to: Index
    end

    def do_run_operation_failed(operation)
      flash.failure = Rex.t(:"action.email_confirmation.destroy.failure")
      redirect_back fallback: Index
    end

    getter email_confirmation : EmailConfirmation do
      EmailConfirmationQuery.find(email_confirmation_id)
    end
  end
end
