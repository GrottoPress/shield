module Shield::BearerLogin
  macro included
    include Shield::BelongsToUser
    include Lucille::StatusColumns

    column name : String
    column scopes : Array(String)
    column token_digest : String
  end
end
