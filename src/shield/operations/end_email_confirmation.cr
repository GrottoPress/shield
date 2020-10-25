module Shield::EndEmailConfirmation
  macro included
    include Shield::EndAuthentication
    include Shield::DeleteSession(EmailConfirmationSession)
  end
end
