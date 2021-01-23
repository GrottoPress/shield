module Shield::DeleteLogin
  macro included
    param_key :login

    needs record : Login

    include Shield::DeleteOperation
  end
end
