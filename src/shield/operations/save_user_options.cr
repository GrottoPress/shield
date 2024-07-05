module Shield::SaveUserOptions # UserOptions::SaveOperation
  macro included
    permit_columns :password_notify

    before_save do
      validate_user_id_required
      validate_password_notify_required
    end

    include Lucille::ValidateUserExists

    private def validate_password_notify_required
      validate_required password_notify,
        message: Rex.t(:"operation.error.password_notify_required")
    end

    private def validate_user_id_required
      validate_required user_id,
        message: Rex.t(:"operation.error.user_id_required")
    end
  end
end
