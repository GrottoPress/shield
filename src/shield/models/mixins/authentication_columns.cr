module Shield::AuthenticationColumns
  macro included
    include Shield::StatusColumns

    skip_default_columns
    primary_key id : Int64

    column token_digest : String
  end
end
