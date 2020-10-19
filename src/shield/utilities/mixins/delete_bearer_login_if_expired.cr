module Shield::DeleteBearerLoginIfExpired
  macro included
    private def expire
      bearer_login!.delete,
    rescue
      true
    end
  end
end
