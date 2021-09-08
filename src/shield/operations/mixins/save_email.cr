module Shield::SaveEmail
  macro included
    getter? user_email = false

    before_save do
      validate_email_required
      validate_email_valid

      set_user_email
      validate_email_unique
    end

    private def validate_email_required
      validate_required email
    end

    private def validate_email_valid
      validate_email email
    end

    private def set_user_email
      email.value.try do |value|
        query = UserQuery.new.email(value)
        record.try { |record| query = query.id.not.eq(record.id) }
        @user_email = query.any?
      end
    end

    private def validate_email_unique
      email.value.try do |value|
        email.add_error("is already taken") if user_email?
      end
    end
  end
end
