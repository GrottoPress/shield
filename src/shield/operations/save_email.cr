module Shield::SaveEmail
  macro included
    permit_columns :email

    before_save do
      downcase_email

      validate_email
      validate_uniqueness_of email
    end

    private def downcase_email
      email.value.try { |value| email.value = value.downcase }
    end

    private def validate_email
      email.value.try do |value|
        email.add_error("format invalid") unless value.email?
      end
    end
  end
end
