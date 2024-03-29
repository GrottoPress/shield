module Shield::SaveLoginUserOptions
  macro included
    permit_columns :login_notify

    before_save do
      validate_login_notify_required
    end

    private def validate_login_notify_required
      validate_required login_notify,
        message: Rex.t(:"operation.error.login_notify_required")
    end
  end
end
