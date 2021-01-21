module Shield::SetSession
  macro included
    needs session : Lucky::Session?

    after_commit set_session
  end
end
