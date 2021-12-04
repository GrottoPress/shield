module Shield::SaveUserOptions
  macro included
    permit_columns :password_notify

    before_save do
      validate_user_id_required
      validate_password_notify_required
      validate_user_exists
    end

    private def validate_password_notify_required
      validate_required password_notify,
        message: Rex.t(:"operation.error.password_notify_required")
    end

    private def validate_user_id_required
      validate_required user_id,
        message: Rex.t(:"operation.error.user_id_required")
    end

    private def validate_user_exists
      return unless user_id.changed?

      validate_foreign_key user_id,
        query: UserQuery,
        message: Rex.t(
          :"operation.error.user_not_found",
          user_id: user_id.value
        )
    end
  end
end
