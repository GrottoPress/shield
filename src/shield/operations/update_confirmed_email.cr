module Shield::UpdateConfirmedEmail # EmailConfirmation::SaveOperation
  macro included
    before_save do
      set_success
      validate_user_id_required
    end

    after_save update_email
    after_save end_email_confirmations

    include Shield::EndEmailConfirmation

    private def validate_user_id_required
      validate_required user_id,
        message: Rex.t(:"operation.error.user_id_required")
    end

    private def set_success
      success.value = true
    end

    private def update_email(email_confirmation : Shield::EmailConfirmation)
      email_confirmation.user!.try do |user|
        UpdateUser.update!(
          user,
          email: email_confirmation.email,
          current_login: nil
        )
      end
    end

    private def end_email_confirmations(
      email_confirmation : Shield::EmailConfirmation
    )
      EmailConfirmationQuery.new
        .email(email_confirmation.email)
        .is_active
        .update(inactive_at: Time.utc)
    end
  end
end
