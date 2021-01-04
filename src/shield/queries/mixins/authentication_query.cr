module Shield::AuthenticationQuery
  macro included
    def is_active
      where "(ended_at IS NULL OR ended_at > ?)",
        Time.adapter.parse(Time.utc).value.to_s
    end
  end
end
