module Shield::DeleteSession
  macro included
    needs session : Lucky::Session? = nil

    after_completed delete_session
  end
end
