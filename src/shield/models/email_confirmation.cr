module Shield::EmailConfirmation
  macro included
    include Shield::AuthenticationColumns
    include Shield::IpAddressColumn

    include Shield::OptionalBelongsToUser
    include Shield::SuccessColumn

    column email : String
  end
end
