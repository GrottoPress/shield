module Shield::EmailConfirmationVerifier
  macro included
    include Shield::Verifier

    def verify : EmailConfirmation?
      return hash unless active?
      email_confirmation if verify?
    end

    def active? : Bool?
      email_confirmation.try &.active?
    end

    def verify? : Bool?
      return unless email_confirmation && email_confirmation_token

      CryptoHelper.verify_sha256?(
        email_confirmation_token!,
        email_confirmation!.token_digest
      )
    end

    # To mitigate timing attacks
    private def hash : Nil
      email_confirmation_token.try { |token| CryptoHelper.hash_sha256(token) }
    end

    def email_confirmation! : EmailConfirmation
      email_confirmation.not_nil!
    end

    @[Memoize]
    def email_confirmation : EmailConfirmation?
      email_confirmation_id.try { |id| EmailConfirmationQuery.new.id(id).first? }
    end

    def email_confirmation_id! : Int64
      email_confirmation_id.not_nil!
    end

    def email_confirmation_token! : String
      email_confirmation_token.not_nil!
    end
  end
end
