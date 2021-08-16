module Shield::DeleteEmailConfirmationsAfterUpdateEmail
  macro included
    private def end_email_confirmations(user : Shield::User)
      EmailConfirmationQuery.new.email(user.email).delete
    end
  end
end
