module Shield::EmailConfirmationQuery
  macro included
    include Shield::AuthenticationQuery
    include Shield::SuccessQuery
  end
end
