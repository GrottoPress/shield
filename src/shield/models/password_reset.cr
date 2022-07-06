module Shield::PasswordReset
  macro included
    include Shield::AuthenticationColumns
    include Shield::IpAddressColumn

    include Shield::BelongsToUser
    include Shield::SuccessColumn
  end
end
