module Shield::LogUserOut
  macro included
    include Shield::EndAuthentication(Login)
    include Shield::DeleteSession(LoginSession)
  end
end
