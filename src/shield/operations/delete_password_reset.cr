module Shield::DeletePasswordReset # PasswordReset::DeleteOperation
  macro included
    include Shield::DeleteSession

    private def delete_session(password_reset : Shield::PasswordReset)
      session.try do |session|
        PasswordResetSession.new(session).delete(password_reset)
      end
    end
  end
end
