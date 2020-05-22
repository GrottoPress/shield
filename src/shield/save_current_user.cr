module Shield::SaveCurrentUser
  macro included
    include Shield::SaveEmail
    include Shield::SavePassword
  end
end
