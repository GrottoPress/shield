module Shield::SaveEmail
  macro included
    getter? user_email = false

    before_save do
      validate_required email
      validate_email email

      set_user_email
      validate_email_unique
    end

    private def set_user_email
      email.value.try do |value|
        @user_email = !!UserQuery.new
          .id.not.eq(record.try(&.id) || 0_i64)
          .email(value).first?
      end
    end

    private def validate_email_unique
      email.value.try do |value|
        email.add_error("is already taken") if user_email?
      end
    end
  end
end
