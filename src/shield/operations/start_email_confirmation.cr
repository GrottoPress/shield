module Shield::StartEmailConfirmation
  macro included
    @email_confirmation = nil

    getter? user_email = false
    getter token = ""

    param_key :email_confirmation

    attribute user_id : Int64
    attribute email : String
    attribute ip_address : String

    needs remote_ip : Socket::IPAddress?

    def submit
      downcase_email

      validate_required email
      validate_email_format

      set_user_email
      set_ip_address
      set_email_confirmation
      set_token

      validate_email_unique
      validate_required ip_address, message: "could not be determined"

      send_user_email

      yield self, send_email
    end

    private def downcase_email
      email.value.try { |value| email.value = value.downcase }
    end

    private def validate_email_format
      email.value.try do |value|
        email.add_error("format is invalid") unless value.email?
      end
    end

    private def set_user_email
      email.value.try do |value|
        @user_email = !!UserQuery.new
          .id.not.eq(user_id.value || 0)
          .email(value).first?
      end
    end

    private def set_ip_address
      ip_address.value = nil
      remote_ip.try { |ip| ip_address.value = ip.address }
    end

    private def set_email_confirmation : EmailConfirmation?
      return unless email.value && ip_address.value

      @email_confirmation = EmailConfirmation.new(
        user_id.value,
        email.value.not_nil!,
        ip_address.value.not_nil!
      )
    end

    private def set_token
      @email_confirmation.try do |object|
        @token = CryptoHelper.encrypt_and_sign(
          object.user_id,
          object.email,
          object.ip_address,
          object.started_at.to_unix
        )
      end
    end

    private def validate_email_unique
      email.value.try do |value|
        email.add_error("is already taken") if user_email?
      end
    end

    private def send_user_email
      return unless user_email?
      mail_later UserEmailConfirmationRequestEmail, self
    end

    private def send_email
      return unless valid?

      mail_later EmailConfirmationRequestEmail,
        self,
        @email_confirmation.not_nil!

      @email_confirmation
    end
  end
end
