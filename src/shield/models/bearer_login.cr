module Shield::BearerLogin
  macro included
    include Shield::AuthenticationColumns(BearerLogin)

    column name : String
    column scopes : Array(String)
  end
end
