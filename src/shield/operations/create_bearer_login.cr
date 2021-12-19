module Shield::CreateBearerLogin
  macro included
    permit_columns :name

    include Shield::SetUserIdFromUser
    include Shield::StartAuthentication

    before_save do
      set_inactive_at

      validate_name_required
      validate_user_id_required
      validate_name_unique
    end

    include Shield::ValidateScopes

    private def validate_name_required
      validate_required name, message: Rex.t(:"operation.error.name_required")
    end

    private def validate_user_id_required
      validate_required user_id,
        message: Rex.t(:"operation.error.user_id_required")
    end

    private def set_inactive_at
      active_at.value.try do |value|
        inactive_at.value = value + Shield.settings.bearer_login_expiry
      end
    end

    # Prevents a user from using a bearer login `name`
    # more than once.
    private def validate_name_unique
      return unless user_id.changed? || name.changed?

      name.value.try do |value|
        return unless uid = user_id.value

        if BearerLoginQuery.new.user_id(uid).name(value).any?
          name.add_error Rex.t(:"operation.error.name_exists", name: value)
        end
      end
    end
  end
end
