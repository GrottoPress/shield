module Shield::SaveUser
  macro included
    include Shield::SaveEmail
    include Shield::SavePassword
  end
end
