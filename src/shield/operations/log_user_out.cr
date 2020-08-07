module Shield::LogUserOut
  macro included
    include Shield::EndAuthentication(Login)

    needs session : Lucky::Session

    after_commit delete_session

    private def delete_session(login : Login)
      LoginSession.new(session).delete
    end
  end
end
