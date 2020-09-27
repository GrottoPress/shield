module Shield::UpdateConfirmedEmail
  macro included
    include Shield::SaveEmail
    include Shield::DeleteSession(EmailConfirmationSession)
  end
end
