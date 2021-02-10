module Shield::SaveLoginUserOptions
  macro included
    permit_columns :login_notify

    before_save do
      validate_required login_notify
    end
  end
end
