module Shield::SaveUserOptions
  macro included
    permit_columns :login_notify, :password_notify

    before_save do
      validate_required login_notify, password_notify, user_id
      validate_exists_by_id user_id, query: UserQuery.new
    end
  end
end
