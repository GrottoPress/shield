module Shield::PasswordReset
  macro included
    include Shield::AuthenticationColumns
    include Shield::IpAddressColumn

    include Shield::BelongsToUser

    column success : Bool
  end
end
