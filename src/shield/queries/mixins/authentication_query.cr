module Shield::AuthenticationQuery
  macro included
    def active
      where "(ended_at IS NULL OR ended_at > ?)",
        Time::Lucky.parse(Time.utc).value.to_s
    end
  end
end
