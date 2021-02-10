module Shield::SaveUserOptions
  macro included
    permit_columns :password_notify

    before_save do
      set_unused_columns

      validate_required password_notify, user_id
      validate_primary_key user_id, query: UserQuery
    end

    private def set_unused_columns
      login_notify.value = false if login_notify.value.nil?
      bearer_login_notify.value = false if bearer_login_notify.value.nil?
    end
  end
end
