module Shield::Login
  macro included
    include Shield::AuthenticationColumns(Login)
  end
end
