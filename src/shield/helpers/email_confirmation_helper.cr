module Shield::EmailConfirmationHelper
  macro extended
    extend self

    def email_confirmation_url(
      email_confirmation : EmailConfirmation,
      operation : StartEmailConfirmation
    ) : String
      email_confirmation_url(email_confirmation.id, operation.token)
    end

    def email_confirmation_url(id, token : String) : String
      email_confirmation_url(BearerToken.new token, id)
    end

    def email_confirmation_url(token : BearerToken) : String
      email_confirmation_url(token.to_s)
    end

    def email_confirmation_url(token : String) : String
      EmailConfirmations::Show.url(token: token)
    end
  end
end
