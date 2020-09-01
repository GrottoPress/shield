module Shield::SaveEmail
  macro included
    include Shield::ValidateEmail

    getter? user_email = false

    before_save do
      validate_required email

      set_user_email
      validate_email_unique
    end

    private def set_user_email
      email.value.try do |value|
        @user_email = !!UserQuery.new
          .id.not.eq(record.try(&.id) || 0)
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
