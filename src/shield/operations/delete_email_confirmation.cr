module Shield::DeleteEmailConfirmation # EmailConfirmation::DeleteOperation
  macro included
    include Shield::DeleteSession

    private def delete_session(email_confirmation : Shield::EmailConfirmation)
      session.try do |session|
        EmailConfirmationSession.new(session).delete(email_confirmation)
      end
    end
  end
end
