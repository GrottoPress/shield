module Shield::DeleteEmailConfirmationIfExpired
  macro included
    private def expire
      email_confirmation!.delete,
    rescue
      true
    end
  end
end
