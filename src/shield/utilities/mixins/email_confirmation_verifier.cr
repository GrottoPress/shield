module Shield::EmailConfirmationVerifier
  macro included
    include Shield::Verifier

    def verify : EmailConfirmation?
      email_confirmation? if verify?
    end

    def verify? : Bool?
      return unless email_confirmation_id? && email_confirmation_token?
      sha256 = Sha256Hash.new(email_confirmation_token)

      if email_confirmation?.try(&.status.active?)
        sha256.verify?(email_confirmation.token_digest)
      else
        sha256.fake_verify
      end
    end

    def email_confirmation
      email_confirmation?.not_nil!
    end

    getter? email_confirmation : EmailConfirmation? do
      email_confirmation_id?.try do |id|
        EmailConfirmationQuery.new.id(id).preload_user.first?
      end
    end

    def email_confirmation_id
      email_confirmation_id?.not_nil!
    end

    def email_confirmation_token : String
      email_confirmation_token?.not_nil!
    end
  end
end
