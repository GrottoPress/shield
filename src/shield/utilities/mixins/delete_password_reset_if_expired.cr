module Shield::DeletePasswordResetIfExpired
  macro included
    private def expire
      password_reset!.delete,
    rescue
      true
    end
  end
end
