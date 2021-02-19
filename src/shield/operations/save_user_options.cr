module Shield::SaveUserOptions
  macro included
    permit_columns :password_notify

    before_save do
      validate_required password_notify, user_id
      validate_primary_key user_id, query: UserQuery
    end
  end
end
