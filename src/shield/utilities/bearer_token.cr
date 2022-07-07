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
      id, _, tkn = token.partition('.')
      new(tkn, id.to_i64?)
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
      io << id?
      io << '.' if id?
      io << @token
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
