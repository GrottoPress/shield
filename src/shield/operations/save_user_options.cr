module Shield::SaveUserOptions
  macro included
    permit_columns :login_notify, :password_notify, :user_id
  end
end
