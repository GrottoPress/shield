module Shield::SetSession
  macro included
    needs session : Lucky::Session? = nil

    after_commit set_session
  end
end
