module Shield::NeverExpires
  macro included
    private def set_ended_at
      ended_at.value = nil
    end
  end
end
