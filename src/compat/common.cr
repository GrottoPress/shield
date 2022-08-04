module Shield::VerificationUrl
  macro included
    @url : String

    def self.new(operation, record)
      new(operation.token, record.id)
    end

    def self.new(token : String, id)
      new BearerToken.new(token, id)
    end

    def self.new(token : Shield::BearerToken)
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

module Shield::BearerToken
  macro included
    getter! :id
    getter :token

    def initialize(@token : String, @id : Int64?)
    end

    def self.new(token : String, id : Number)
      new(token, id.to_i64)
    end

    def self.new(token : String, id)
      new(token, id.to_i64?)
    end

    def self.new(operation, record)
      new(operation.token, record.id)
    end

    def self.new(token : String)
      decoded = Base64.decode_string(token)
      id, _, _token = decoded.partition(':')
      new(_token, id.to_i64?)
    rescue Base64::Error
      new(token, nil)
    end

    def authenticate(headers : HTTP::Headers) : Nil
      headers["Authorization"] = "Bearer #{to_s}"
    end

    def authenticate(client) : Nil
      client.before_request { |request| authenticate(request.headers) }
    end

    def to_param : String
      to_s
    end

    def to_json(json)
      json.string(to_s)
    end

    def to_s(io)
      io << Base64.urlsafe_encode("#{id?}:#{token}", false)
    end

    def self.from_headers(request : HTTP::Request) : self
      from_headers(request.headers)
    end

    def self.from_headers(headers : HTTP::Headers) : self
      from_headers?(headers).not_nil!
    end

    def self.from_headers?(request : HTTP::Request) : self?
      from_headers?(request.headers)
    end

    def self.from_headers?(headers : HTTP::Headers) : self?
      header = headers["Authorization"]?.try &.split
      return unless header.try(&.size) == 2 && header.try(&.[0]?) == "Bearer"
      header.try &.[1]?.try { |token| new(token) }
    end

    def self.from_params(
      params : Avram::Paramable,
      key : String | Symbol = "token"
    ) : self
      from_params?(params, key).not_nil!
    end

    def self.from_params?(
      params : Avram::Paramable,
      key : String | Symbol = "token"
    ) : self?
      params.get?(key.to_s).try { |token| new(token) }
    end
  end
end

module Shield::AuthenticationQuery
  macro included
    {% puts "Warning: Deprecated Shield::AuthenticationQuery" %}

    include Lucille::StatusQuery
  end
end

module Shield::AuthenticationColumns
  macro included
    {% puts "Warning: Deprecated Shield::AuthenticationColumns" %}

    include Lucille::StatusColumns

    column token_digest : String
  end
end

module Shield::EndAuthentication
  macro included
    {% puts "Warning: Deprecated Shield::EndAuthentication" %}

    include Lucille::Deactivate
  end
end

module Shield::StartAuthentication
  macro included
    {% puts "Warning: Deprecated Shield::StartAuthentication" %}

    include Lucille::Activate
    include Shield::SetToken
  end
end

module Shield::ValidateAuthenticationColumns
  macro included
    {% puts "Warning: Deprecated Shield::ValidateAuthenticationColumns" %}

    before_save do
      validate_token_digest_required
    end

    include Lucille::ValidateStatus

    private def validate_token_digest_required
      validate_required token_digest,
        message: Rex.t(:"operation.error.token_required")
    end
  end
end

module Shield::SetUserIdFromUser
  macro included
    {% puts "Warning: Deprecated Shield::SetUserIdFromUser. \
      Use Lucille::SetUserIdFromUser instead" %}

    include Lucille::SetUserIdFromUser
  end
end


struct BearerToken
  include Shield::BearerToken
end
