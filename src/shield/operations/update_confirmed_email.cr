module Shield::UpdateConfirmedEmail
  macro included
    include Shield::SaveEmail

    needs session : Lucky::Session

    after_save delete_session

    private def delete_session(user : User)
      EmailConfirmationSession.new(session).delete
    end
  end
end
