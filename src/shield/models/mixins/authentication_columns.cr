module Shield::AuthenticationColumns
  macro included
    include Shield::StatusColumns

    column token_digest : String
  end
end
