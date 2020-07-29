module Shield::CreatePassword
  macro included
    include Shield::ValidatePassword
    include Shield::SetPasswordHash
  end
end
