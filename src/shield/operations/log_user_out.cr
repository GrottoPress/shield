module Shield::LogUserOut
  macro included
    include Shield::EndAuthentication
    include Shield::DeleteSession

    private def delete_session(login : Login)
      session.try { |session| LoginSession.new(session).delete }
    end
  end
end
