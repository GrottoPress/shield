module Shield::EmailConfirmation
  macro included
    getter user_id : Int64?
    getter email : String
    getter ip_address : String
    getter started_at : Time

    def initialize(@email, @ip_address, @started_at)
    end

    def initialize(@email, @ip_address)
      @started_at = Time.utc
    end

    def initialize(@user_id, @email, @ip_address, @started_at)
    end

    def initialize(@user_id, @email, @ip_address)
      @started_at = Time.utc
    end

    def user_id! : Int64
      user_id.not_nil!
    end

    def user! : User
      user.not_nil!
    end

    def user : User?
      user_id.try { |id| UserQuery.new.id(id).first? }
    end

    def expired? : Bool
      (Time.utc - started_at) > Shield.settings.email_confirmation_expiry
    end

    def url(operation : StartEmailConfirmation) : String
      url(operation.token)
    end

    def url(token : String) : String
      EmailConfirmations::Show.url(token: token)
    end
  end
end
