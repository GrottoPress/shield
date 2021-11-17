module Shield::AuthenticationColumns
  macro included
    include Lucille::StatusColumns

    column token_digest : String
  end
end
