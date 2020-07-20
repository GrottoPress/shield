module Shield::DeactivateLogin
  macro included
    before_save do
      set_ended_at
    end

    private def set_ended_at
      ended_at.value = Time.utc
    end
  end
end
