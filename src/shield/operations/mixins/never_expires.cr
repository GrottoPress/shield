module Shield::NeverExpires
  macro included
    private def set_inactive_at
      inactive_at.value = nil
    end
  end
end
