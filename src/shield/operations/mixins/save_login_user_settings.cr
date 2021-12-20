module Shield::SaveLoginUserSettings
  macro included
    attribute login_notify : Bool

    before_save do
      set_login_notify
      validate_login_notify_required
    end

    private def validate_login_notify_required
      return unless new_record?

      validate_required login_notify,
        message: Rex.t(:"operation.error.login_notify_required")
    end

    private def set_login_notify
      login_notify.value.try do |value|
        settings.value.try do |_settings|
          return settings.value = _settings.merge(login_notify: value)
        end

        settings.value = UserSettings.from_json({login_notify: value}.to_json)
      end
    end
  end
end
