module Shield::EndPasswordReset
  macro included
    include Shield::EndAuthentication(PasswordReset, PasswordResetSession)
  end
end
