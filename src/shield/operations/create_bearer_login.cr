module Shield::CreateBearerLogin
  macro included
    permit_columns :name

    include Shield::SetUserIdFromUser
    include Shield::StartAuthentication

    before_save do
      set_inactive_at
    end

    include Shield::ValidateBearerLogin

    private def validate_user_exists
      return if user
      previous_def
    end

    private def set_inactive_at
      active_at.value.try do |value|
        inactive_at.value = value + Shield.settings.bearer_login_expiry
      end
    end
  end
end
