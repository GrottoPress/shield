module Shield::SaveCurrentUser
  macro included
    include Shield::SaveEmail
    include Shield::SavePassword
    include Shield::UserSaveUserOptions
  end
end
