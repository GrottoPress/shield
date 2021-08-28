module Shield::CreateBearerLogin
  macro included
    permit_columns :name

    include Shield::SetUserIdFromUser

    before_save do
      validate_name_required
      validate_user_id_required
      validate_name_unique
    end

    include Shield::ValidateScopes
    include Shield::StartAuthentication

    private def validate_name_required
      validate_required name
    end

    private def validate_user_id_required
      validate_required user_id
    end

    private def set_inactive_at
      inactive_at.value = active_at.value.not_nil! + \
        Shield.settings.bearer_login_expiry
    end

    # Prevents a user from using a bearer login `name`
    # more than once.
    private def validate_name_unique
      return unless valid?

      name.value.try do |value|
        return unless uid = user_id.value

        if BearerLoginQuery.new.user_id(uid).name(value).any?
          name.add_error("is already used")
        end
      end
    end
  end
end
