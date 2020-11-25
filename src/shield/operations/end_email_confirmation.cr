module Shield::EndEmailConfirmation
  macro included
    include Shield::EndAuthentication
    include Shield::DeleteSession

    private def delete_session(email_confirmation : EmailConfirmation)
      session.try { |session| EmailConfirmationSession.new(session).delete }
    end
  end
end
