module Shield::PasswordReset
  macro included
    include Shield::AuthenticationColumns(PasswordReset)
    include Shield::IpAddressColumn

    include Shield::BelongsToUser
  end
end
