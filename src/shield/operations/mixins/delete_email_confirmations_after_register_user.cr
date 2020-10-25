module Shield::DeleteEmailConfirmationsAfterRegisterUser
  macro included
    private def set_email_confirmation_user(user : User)
    end

    private def end_email_confirmations(user : User)
      EmailConfirmationQuery.new.email(user.email).delete
    end
  end
end
