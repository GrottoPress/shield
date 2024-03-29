module Shield::SaveBearerLoginUserSettings
  macro included
    attribute bearer_login_notify : Bool

    before_save do
      set_bearer_login_notify
      validate_bearer_login_notify_required
    end

    private def validate_bearer_login_notify_required
      return unless new_record?
      validate_required bearer_login_notify,
        message: Rex.t(:"operation.error.bearer_login_notify_required")
    end

    private def set_bearer_login_notify
      bearer_login_notify.value.try do |value|
        values = {bearer_login_notify: value}

        settings.value.try do |_settings|
          return settings.value = _settings.merge(**values)
        end

        settings.value = UserSettings.from_json(values.to_json)
      end
    end
  end
end
