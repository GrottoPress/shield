module Shield::LogUserOut
  macro included
    include Shield::DeactivateLogin

    needs session : Lucky::Session

    after_commit delete_session

    private def delete_session(login : Login)
      Login.delete_session(session)
    end
  end
end
