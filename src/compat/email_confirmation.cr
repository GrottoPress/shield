module Shield::Api::EmailConfirmations::Edit
  macro included
    {% puts "Warning: Deprecated `Shield::Api::EmailConfirmations::Edit`. \
      Use `Shield::Api::EmailConfirmations::Update` instead" %}

    include Shield::Api::EmailConfirmations::Update
  end
end

module Shield::EmailConfirmations::Edit
  macro included
    {% puts "Warning: Deprecated `Shield::EmailConfirmations::Edit`. \
      Use `Shield::EmailConfirmations::Update` instead" %}

    include Shield::EmailConfirmations::Update
  end
end

module Shield::EmailConfirmationHelpers
  macro included
    @[Deprecated("Redirect to `EmailConfirmationCredentials#url` instead")]
    def redirect(to path : Shield::EmailConfirmationUrl, status : Int32 = 302)
      redirect(path.to_s, status)
    end
  end
end

module Shield::EmailConfirmationUrl
  macro included
    include Shield::VerificationUrl

    def initialize(token : String)
      @url = Shield.settings.email_confirmation_url.call(token)
    end
  end
end

struct EmailConfirmationUrl
  include Shield::EmailConfirmationUrl
end
