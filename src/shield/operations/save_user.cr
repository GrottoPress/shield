module Shield::SaveUser
  macro included
    include Shield::SaveEmail
    include Shield::SavePassword
    include Shield::UserSaveUserOptions
  end
end
