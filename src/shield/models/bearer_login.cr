module Shield::BearerLogin
  macro included
    include Shield::AuthenticationColumns(BearerLogin)
    include Shield::BelongsToUser

    column name : String
    column scopes : Array(String)
  end
end
