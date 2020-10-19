module Shield::DeleteLoginIfExpired
  macro included
    private def expire
      login!.delete,
    rescue
      true
    end
  end
end
