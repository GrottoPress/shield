module Shield::SaveUserOptions
  macro included
    permit_columns :login_notify, :password_notify
  end
end
