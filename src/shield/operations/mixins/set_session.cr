module Shield::SetSession
  macro included
    needs session : Lucky::Session? = nil

    after_completed set_session
  end
end
