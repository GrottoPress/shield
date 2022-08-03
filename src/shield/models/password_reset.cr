module Shield::PasswordReset
  macro included
    include Shield::IpAddressColumn
    include Shield::BelongsToUser
    include Lucille::SuccessStatusColumns

    column token_digest : String
  end
end
