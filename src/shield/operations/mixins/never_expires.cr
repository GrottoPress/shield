module Shield::NeverExpires
  macro included
    private def set_default_inactive_at
      inactive_at.value = nil
    end
  end
end
