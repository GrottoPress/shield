module Shield::DeleteSession
  macro included
    needs session : Lucky::Session?

    after_commit delete_session
  end
end
