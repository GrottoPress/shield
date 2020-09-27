module Shield::DeleteSession(U)
  macro included
    needs session : Lucky::Session? = nil

    after_commit delete_session

    private def delete_session(saved_record)
      session.try { |session| U.new(session).delete }
    end
  end
end
