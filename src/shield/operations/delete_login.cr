module Shield::DeleteLogin # Login::DeleteOperation
  macro included
    include Shield::DeleteSession

    private def delete_session(login : Shield::Login)
      session.try do |session|
        LoginSession.new(session).delete(login)
        LoginIdleTimeoutSession.new(session).delete(login)
      end
    end
  end
end
