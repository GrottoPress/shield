module Shield::DeactivateLogin
  macro included
    include Shield::EndAuthentication(Login)
  end
end
