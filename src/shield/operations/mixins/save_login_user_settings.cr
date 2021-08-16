module Shield::SaveLoginUserSettings
  macro included
    attribute login_notify : Bool

    before_save do
      validate_login_notify_required
      set_login_notify
    end

    private def validate_login_notify_required
      return unless new_record?
      validate_required login_notify
    end

    private def set_login_notify
      login_notify.value.try do |value|
        if settings.value
          settings.value.try &.login_notify = value
          settings.value = settings.value.dup # Ensures `#changed?` is `true`
        else
          settings.value = UserSettings.from_json({login_notify: value}.to_json)
        end
      end
    end
  end
end
