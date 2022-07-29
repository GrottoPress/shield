module Shield::EmailConfirmationCredentials
  macro included
    include Shield::ParamCredentials

    def initialize(
      @password : String,
      @id : {{ EmailConfirmation::PRIMARY_KEY_TYPE }}
    )
    end

    def self.new(
      operation : Shield::StartEmailConfirmation,
      record : Shield::EmailConfirmation
    )
      new(operation.token, record.id)
    end

    def email_confirmation : EmailConfirmation
      email_confirmation?.not_nil!
    end

    getter? email_confirmation : EmailConfirmation? do
      EmailConfirmationQuery.new.id(id).first?
    end

    def url : String
      Shield.settings.email_confirmation_url.call(to_s)
    end
  end
end
