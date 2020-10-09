module Shield::PasswordReset
  macro included
    include Shield::AuthenticationColumns(PasswordReset)
    include Shield::IpAddressColumn
  end
end
