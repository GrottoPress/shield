module Shield::HasManyPasswordResets
  macro included
    has_many password_resets : PasswordReset
  end
end
