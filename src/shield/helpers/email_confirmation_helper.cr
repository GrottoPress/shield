module Shield::EmailConfirmationHelper
  macro extended
    extend self

    def email_confirmation_url(
      email_confirmation : EmailConfirmation,
      operation : StartEmailConfirmation
    ) : String
      email_confirmation_url(token email_confirmation, operation)
    end

    def email_confirmation_url(id, token : String) : String
      email_confirmation_url(token id, token)
    end

    def email_confirmation_url(token : String) : String
      EmailConfirmations::Show.url(token: token)
    end

    def token(
      email_confirmation : EmailConfirmation,
      operation : StartEmailConfirmation
    ) : String
      token(email_confirmation.id, operation.token)
    end

    def token(id, token : String) : String
      LoginHelper.token(id, token)
    end
  end
end
