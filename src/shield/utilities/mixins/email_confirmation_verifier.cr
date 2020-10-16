module Shield::EmailConfirmationVerifier
  macro included
    include Shield::Verifier

    def verify : EmailConfirmation?
      email_confirmation unless expired?
    end

    def expired? : Bool?
      email_confirmation.try &.expired?
    end

    def email_confirmation! : EmailConfirmation
      email_confirmation.not_nil!
    end

    def email_confirmation : EmailConfirmation?
      return unless email_confirmation_email &&
        email_confirmation_ip_address &&
        email_confirmation_started_at

      EmailConfirmation.new(
        email_confirmation_user_id,
        email_confirmation_email!,
        email_confirmation_ip_address!,
        email_confirmation_started_at!
      )
    end

    def email_confirmation_user! : User
      email_confirmation_user.not_nil!
    end

    def email_confirmation_user_id! : Int64
      email_confirmation_user_id.not_nil!
    end

    def email_confirmation_email! : String
      email_confirmation_email.not_nil!
    end

    def email_confirmation_ip_address! : String
      email_confirmation_ip_address.not_nil!
    end

    def email_confirmation_started_at! : Time
      email_confirmation_started_at.not_nil!
    end

    @[Memoize]
    def email_confirmation_user : User?
      email_confirmation_user_id.try { |id| UserQuery.new.id(id).first? }
    end
  end
end
