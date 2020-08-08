module Shield::PasswordReset
  macro included
    include Shield::AuthenticationColumns(PasswordReset)
  end
end
