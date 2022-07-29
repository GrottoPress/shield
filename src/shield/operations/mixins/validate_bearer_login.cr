module Shield::ValidateBearerLogin
  macro included
    before_save do
      ensure_scopes_unique

      validate_name_required
      validate_user_id_required
      validate_name_valid
      validate_name_unique
      validate_user_exists

      validate_scopes_required
      validate_scopes_not_empty
      validate_scopes_valid
    end

    include Shield::ValidateAuthenticationColumns

    private def ensure_scopes_unique
      scopes.value = scopes.value.try(&.uniq)
    end

    private def validate_name_required
      validate_required name, message: Rex.t(:"operation.error.name_required")
    end

    private def validate_user_id_required
      validate_required user_id,
        message: Rex.t(:"operation.error.user_id_required")
    end

    private def validate_name_valid
      name.value.try do |value|
        return if value.matches?(/^[a-z\_][a-z0-9\s\_\-\(\)]*$/i)
        name.add_error Rex.t(:"operation.error.name_invalid", name: value)
      end
    end

    private def validate_name_unique
      return unless name.changed? || user_id.changed?

      name.value.try do |_name|
        user_id.value.try do |_user_id|
          if BearerLoginQuery.new.user_id(_user_id).name(_name).any?
            name.add_error Rex.t(:"operation.error.name_exists", name: _name)
          end
        end
      end
    end

    private def validate_scopes_required
      validate_required scopes,
        message: Rex.t(:"operation.error.bearer_scopes_required")
    end

    private def validate_scopes_not_empty
      scopes.value.try do |value|
        return unless value.empty?
        scopes.add_error Rex.t(:"operation.error.bearer_scopes_empty")
      end
    end

    private def validate_scopes_valid
      scopes.value.try do |value|
        allowed_scopes = Shield.settings.bearer_login_allowed_scopes
        return if value.all? &.in?(allowed_scopes)

        scopes.add_error Rex.t(:"operation.error.bearer_scopes_invalid")
      end
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
