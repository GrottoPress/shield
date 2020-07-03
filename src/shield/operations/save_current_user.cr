module Shield::SaveCurrentUser
  macro included
    include Shield::SaveEmail
    include Shield::SavePassword
    include Shield::UserNestedSaveOperations
  end
end
