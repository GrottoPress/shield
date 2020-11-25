module Shield::EndPasswordReset
  macro included
    include Shield::EndAuthentication
    include Shield::DeleteSession

    private def delete_session(password_reset : PasswordReset)
      session.try { |session| PasswordResetSession.new(session).delete }
    end
  end
end
