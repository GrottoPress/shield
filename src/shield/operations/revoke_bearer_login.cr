module Shield::RevokeBearerLogin
  macro included
    include Shield::EndAuthentication
  end
end
