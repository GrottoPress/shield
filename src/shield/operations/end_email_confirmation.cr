module Shield::EndEmailConfirmation
  macro included
    include Shield::EndAuthentication(EmailConfirmation)
    include Shield::DeleteSession(EmailConfirmationSession)
  end
end
