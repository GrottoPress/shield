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
        @user_email = UserQuery.new
          .id.not.eq(record.try(&.id) || 0_i64)
          .email(value).any?
      end
    end

    private def validate_email_unique
      email.value.try do |value|
        email.add_error("is already taken") if user_email?
      end
    end
  end
end
