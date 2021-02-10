module Shield::SaveBearerLoginUserOptions
  macro included
    permit_columns :bearer_login_notify

    before_save do
      validate_required bearer_login_notify
    end
  end
end
