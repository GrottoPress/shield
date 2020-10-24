module Shield::SetEmailFromEmailConfirmation
  macro included
    needs email_confirmation : EmailConfirmation

    before_save do
      set_email
    end

    private def set_email
      email.value = email_confirmation.email
    end
  end
end
