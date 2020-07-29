module Shield::LogUserOut
  macro included
    include Shield::EndAuthentication(Login)

    needs session : Lucky::Session

    after_commit delete_session

    private def delete_session(login : Login)
      VerifyLogin.new(params, session: session).delete_session
    end
  end
end
