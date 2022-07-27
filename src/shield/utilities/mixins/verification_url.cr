module Shield::VerificationUrl
  macro included
    @url : String

    def self.new(operation, record)
      new(operation.token, record.id)
    end

    def self.new(token : String, id)
      new BearerCredentials.new(token, id)
    end

    def self.new(token : Shield::BearerCredentials)
      new(token.to_s)
    end

    def to_param : String
      to_s
    end

    def to_json(json)
      json.string(to_s)
    end

    def to_s(io)
      io << @url
    end
  end
end
