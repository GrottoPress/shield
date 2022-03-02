module Shield::EmailConfirmation
  macro included
    include Shield::AuthenticationColumns
    include Shield::IpAddressColumn

    include Shield::OptionalBelongsToUser

    column email : String
    column success : Bool
  end
end
