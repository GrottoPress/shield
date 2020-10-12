module Shield::RevokeBearerLogin
  macro included
    include Shield::EndAuthentication(BearerLogin)
  end
end
