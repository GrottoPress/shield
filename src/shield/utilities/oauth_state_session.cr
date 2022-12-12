module Shield::OauthStateSession
  macro included
    def initialize(@session : Lucky::Session)
    end

    def self.new(context : HTTP::Server::Context)
      new(context.session)
    end

    def state : String
      state?.not_nil!
    end

    def state?(*, delete = false) : String?
      @session.get?(:oauth_state).try do |value|
        self.delete if delete
        value
      end
    end

    def delete : self
      @session.delete(:oauth_state)
      self
    end

    def set(state : String) : self
      @session.set(:oauth_state, state)
      self
    end
  end
end
