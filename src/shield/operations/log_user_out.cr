module Shield::LogUserOut
  macro included
    include Shield::EndAuthentication
    include Shield::DeleteSession(LoginSession)
  end
end
