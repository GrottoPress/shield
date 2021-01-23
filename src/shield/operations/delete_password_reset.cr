module Shield::DeletePasswordReset
  macro included
    param_key :password_reset

    needs record : PasswordReset

    include Shield::DeleteOperation
  end
end
