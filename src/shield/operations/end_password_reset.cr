module Shield::EndPasswordReset
  macro included
    include Shield::EndAuthentication
    include Shield::DeleteSession(PasswordResetSession)
  end
end
