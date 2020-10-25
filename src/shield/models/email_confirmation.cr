module Shield::EmailConfirmation
  macro included
    include Shield::AuthenticationColumns
    include Shield::IpAddressColumn

    include Shield::OptionalBelongsToUser

    column email : String
  end
end
