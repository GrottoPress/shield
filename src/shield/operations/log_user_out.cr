module Shield::LogUserOut
  macro included
    include Shield::EndAuthentication(Login, LoginSession)
  end
end
