module Shield::SaveUserOptions
  macro included
    param_key :user

    permit_columns :login_notify, :password_notify

    before_save do
      validate_required login_notify, password_notify
      validate_required user_id, message: "does not exist"
    end
  end
end
