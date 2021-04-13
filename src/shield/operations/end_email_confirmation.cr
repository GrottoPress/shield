module Shield::EndEmailConfirmation
  macro included
    include Shield::EndAuthentication
    include Shield::DeleteSession

    private def delete_session(email_confirmation : EmailConfirmation)
      session.try do |session|
        EmailConfirmationSession.new(session).delete(email_confirmation)
      end
    end
  end
end
