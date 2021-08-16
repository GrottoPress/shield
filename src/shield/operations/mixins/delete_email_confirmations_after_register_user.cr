module Shield::DeleteEmailConfirmationsAfterRegisterUser
  macro included
    private def set_email_confirmation_user(user : Shield::User)
    end

    private def end_email_confirmations(user : Shield::User)
      EmailConfirmationQuery.new.email(user.email).delete
    end
  end
end
