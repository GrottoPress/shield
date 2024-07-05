module Shield::DeleteEmailConfirmationsAfterRegisterUser
  macro included
    after_save delete_email_confirmations

    private def end_email_confirmations(user : Shield::User)
    end

    private def delete_email_confirmations(user : Shield::User)
      EmailConfirmationQuery.new.email(user.email).delete
    end
  end
end
