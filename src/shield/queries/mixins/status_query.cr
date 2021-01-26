module Shield::StatusQuery
  macro included
    def is_active
      where "(inactive_at IS NULL OR inactive_at > ?)",
        Time.adapter.parse(Time.utc).value.to_s
    end
  end
end
