module Shield::DeleteLoginsOnPasswordChange
  macro included
    private def log_out_everywhere(user : Shield::User)
      return unless password_digest.changed?

      query = LoginQuery.new.user_id(user.id)
      current_login.try { |login| query = query.id.not.eq(login.id) }
      query.delete
    end
  end
end
