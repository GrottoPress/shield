module Shield::Login
  macro included
    include Shield::IpAddressColumn
    include Shield::BelongsToUser
    include Lucille::StatusColumns

    column token_digest : String
  end
end
