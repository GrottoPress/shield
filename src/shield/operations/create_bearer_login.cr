module Shield::CreateBearerLogin
  macro included
    permit_columns :name, :scopes

    include Lucille::SetUserIdFromUser
    include Lucille::Activate
    include Shield::SetToken

    before_save do
      set_inactive_at
    end

    include Shield::ValidateBearerLogin

    private def validate_user_exists
      return if user
      previous_def
    end

    private def set_inactive_at
      Shield.settings.bearer_login_expiry.try do |expiry|
        active_at.value.try { |value| inactive_at.value = value + expiry }
      end
    end
  end
end
