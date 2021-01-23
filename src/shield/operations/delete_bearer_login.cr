module Shield::DeleteBearerLogin
  macro included
    param_key :bearer_login

    needs record : BearerLogin

    include Shield::DeleteOperation
  end
end
