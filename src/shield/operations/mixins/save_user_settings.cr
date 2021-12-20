module Shield::SaveUserSettings
  macro included
    attribute password_notify : Bool

    before_save do
      set_password_notify
      validate_password_notify_required
    end

    private def validate_password_notify_required
      return unless new_record?

      validate_required password_notify,
        message: Rex.t(:"operation.error.password_notify_required")
    end

    private def set_password_notify
      password_notify.value.try do |value|
        settings.value.try do |_settings|
          return settings.value = _settings.merge(password_notify: value)
        end

        settings.value = UserSettings.from_json(
          {password_notify: value}.to_json
        )
      end
    end
  end
end
