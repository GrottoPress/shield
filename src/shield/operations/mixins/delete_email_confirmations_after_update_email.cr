module Shield::DeleteEmailConfirmationsAfterUpdateEmail
  macro included
    private def end_email_confirmations(user : User)
      EmailConfirmationQuery.new.email(user.email).delete
    end
  end
end
