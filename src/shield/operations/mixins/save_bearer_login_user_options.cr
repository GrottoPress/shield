module Shield::SaveBearerLoginUserOptions
  macro included
    permit_columns :bearer_login_notify

    before_save do
      validate_bearer_login_notify_required
    end

    private def validate_bearer_login_notify_required
      validate_required bearer_login_notify
    end
  end
end
