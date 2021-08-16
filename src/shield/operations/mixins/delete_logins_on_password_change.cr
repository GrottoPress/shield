module Shield::DeleteLoginsOnPasswordChange
  macro included
    private def log_out_everywhere(user : Shield::User)
      return unless password_digest.changed?

      LoginQuery.new
        .user_id(user.id)
        .id.not.eq(current_login.try(&.id) || 0_i64)
        .delete
    end
  end
end
