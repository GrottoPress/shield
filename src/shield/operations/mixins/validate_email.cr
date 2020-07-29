module Shield::ValidateEmail
  macro included
    before_save do
      downcase_email

      validate_email_format
    end

    private def downcase_email
      email.value.try { |value| email.value = value.downcase }
    end

    private def validate_email_format
      email.value.try do |value|
        email.add_error("format is invalid") unless value.email?
      end
    end
  end
end
