module Shield::EndPasswordReset
  macro included
    include Shield::EndAuthentication(PasswordReset)
  end
end
