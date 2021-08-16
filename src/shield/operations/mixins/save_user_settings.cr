module Shield::SaveUserSettings
  macro included
    attribute password_notify : Bool

    before_save do
      validate_password_notify_required
      set_password_notify
    end

    private def validate_password_notify_required
      return unless new_record?
      validate_required password_notify
    end

    private def set_password_notify
      password_notify.value.try do |value|
        if settings.value
          settings.value.try &.password_notify = value
          settings.value = settings.value.dup # Ensures `#changed?` is `true`
        else
          settings.value = UserSettings.from_json(
            {password_notify: value}.to_json
          )
        end
      end
    end
  end
end
