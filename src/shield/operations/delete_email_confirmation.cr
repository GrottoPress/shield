module Shield::DeleteEmailConfirmation
  macro included
    param_key :email_confirmation

    needs record : EmailConfirmation

    include Shield::DeleteOperation
  end
end
