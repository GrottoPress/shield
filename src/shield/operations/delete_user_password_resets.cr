module Shield::DeleteUserPasswordResets # User::SaveOperation
  macro included
    after_commit delete_password_resets

    private def delete_password_resets(user : Shield::User)
      PasswordResetQuery.new.user_id(user.id).delete
    end
  end
end
