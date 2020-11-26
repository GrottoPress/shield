module Shield::LogUserOut
  macro included
    include Shield::EndAuthentication
    include Shield::DeleteSession

    private def delete_session(login : Login)
      session.try do |session|
        LoginSession.new(session).delete
        LoginIdleTimeoutSession.new(session).delete
      end
    end
  end
end
