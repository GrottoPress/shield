module Shield::LogUserOut
  macro included
    include Shield::EndAuthentication
    include Shield::DeleteSession

    private def delete_session(login : Login)
      session.try do |session|
        LoginSession.new(session).delete(login)
        LoginIdleTimeoutSession.new(session).delete(login)
      end
    end
  end
end
