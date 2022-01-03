module Shield::LoginIdleTimeoutSession
  macro included
    include Shield::Session

    def expired? : Bool?
      Shield.settings.login_idle_timeout.try do |timeout|
        login_last_active?.try { |time| Time.utc - time >= timeout }
      end
    end

    def login_last_active : Time
      login_last_active?.not_nil!
    end

    def login_last_active? : Time?
      @session.get?(:login_last_active).try &.to_i64?.try do |time|
        Time.unix(time)
      end
    end

    def delete(login : Shield::Login) : self
      delete if login.id == LoginSession.new(@session).login_id?
      self
    end

    def delete : self
      @session.delete(:login_last_active)
      self
    end

    def set : self
      @session.set(:login_last_active, Time.utc.to_unix.to_s)
      self
    end
  end
end
