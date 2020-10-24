module Shield::HasManyEmailConfirmations
  macro included
    has_many email_confirmations : EmailConfirmation
  end
end
