module Shield::SaveBearerLoginUserOptions
  macro included
    permit_columns :bearer_login_notify

    before_save do
      validate_bearer_login_notify_required
    end

    private def validate_bearer_login_notify_required
      validate_required bearer_login_notify,
        message: Rex.t(:"operation.error.bearer_login_notify_required")
    end
  end
end
