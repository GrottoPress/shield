module Shield::EmailConfirmation
  macro included
    include Shield::IpAddressColumn
    include Shield::OptionalBelongsToUser
    include Lucille::SuccessStatusColumns

    column email : String
    column token_digest : String
  end
end
