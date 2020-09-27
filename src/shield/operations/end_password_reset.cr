module Shield::EndPasswordReset
  macro included
    include Shield::EndAuthentication(PasswordReset)
    include Shield::DeleteSession(PasswordResetSession)
  end
end
