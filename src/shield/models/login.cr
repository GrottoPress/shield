module Shield::Login
  macro included
    include Shield::AuthenticationColumns(Login)
    include Shield::IpAddressColumn

    include Shield::BelongsToUser
  end
end
