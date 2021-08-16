module Shield::VerificationUrl
  macro included
    getter route : Lucky::RouteHelper

    def self.new(operation, record)
      new(operation.token, record.id)
    end

    def self.new(token : String, id)
      new(BearerToken.new token, id)
    end

    def self.new(token : Shield::BearerToken)
      new(token.to_s)
    end

    def to_s(io)
      io << @route.url
    end

    def to_json(json)
      json.string(to_s)
    end
  end
end
