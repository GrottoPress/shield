module Shield::BearerToken
  macro included
    getter id : Int64
    getter :token

    def initialize(@token : String, id : Number)
      @id = id.to_i64
    end

    def self.new(operation, record)
      new(operation.token, record.id)
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
      io << "#{id}.#{token}"
    end

    def self.from_token(token) : self
      from_token?(token).not_nil!
    end

    def self.from_token?(token : String) : self?
      id, _, rest = token.partition('.')
      return if rest.empty?

      id.to_i64?.try { |id| new(rest, id) }
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
      header.try &.[1]?.try { |token| from_token?(token) }
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
      params.get?(key.to_s).try { |token| from_token?(token) }
    end
  end
end
