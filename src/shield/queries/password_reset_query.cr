module Shield::PasswordResetQuery
  macro included
    include Shield::AuthenticationQuery
    include Shield::SuccessQuery
  end
end
