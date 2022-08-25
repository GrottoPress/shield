module Shield::SaveOauthClientUserSettings
  macro included
    attribute oauth_access_token_notify : Bool

    before_save do
      set_oauth_access_token_notify
      validate_oauth_access_token_notify_required
    end

    private def validate_oauth_access_token_notify_required
      return unless new_record?

      validate_required oauth_access_token_notify,
        message: Rex.t(:"operation.error.oauth_access_token_notify_required")
    end

    private def set_oauth_access_token_notify
      oauth_access_token_notify.value.try do |value|
        values = {oauth_access_token_notify: value}

        settings.value.try do |_settings|
          return settings.value = _settings.merge(**values)
        end

        settings.value = UserSettings.from_json(values.to_json)
      end
    end
  end
end
