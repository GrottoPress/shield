module Shield::Api::EmailConfirmations::Delete
  macro included
    include Shield::Api::EmailConfirmations::Destroy

    # delete "/email-confirmations/:email_confirmation_id" do
    #   run_operation
    # end

    def run_operation
      DeleteEmailConfirmation.delete(
        email_confirmation,
        session: nil
      ) do |operation, deleted_email_confirmation|
        if operation.deleted?
          do_run_operation_succeeded(
            operation,
            deleted_email_confirmation.not_nil!
          )
        else
          response.status_code = 400
          do_run_operation_failed(operation)
        end
      end
    end
  end
end
