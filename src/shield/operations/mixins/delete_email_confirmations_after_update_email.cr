module Shield::DeleteEmailConfirmationsAfterUpdateEmail
  macro included
    after_commit delete_email_confirmations

    private def end_email_confirmations(
      email_confirmation : Shield::EmailConfirmation
    )
    end

    private def delete_email_confirmations(
      email_confirmation : Shield::EmailConfirmation
    )
      EmailConfirmationQuery.new.email(email_confirmation.email).delete
    end
  end
end
