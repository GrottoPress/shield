module Shield::EndPasswordReset
  macro included
    include Shield::EndAuthentication
    include Shield::DeleteSession

    private def delete_session(password_reset : PasswordReset)
      session.try do |session|
        PasswordResetSession.new(session).delete(password_reset)
      end
    end
  end
end
