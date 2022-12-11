module Shield::OauthGrantType
  macro included
    AUTHORIZATION_CODE = "authorization_code"
    CLIENT_CREDENTIALS = "client_credentials"
    REFRESH_TOKEN = "refresh_token"

    def initialize(@grant_type : String?)
    end

    def authorization_code? : Bool
      @grant_type == AUTHORIZATION_CODE
    end

    def client_credentials? : Bool
      @grant_type == CLIENT_CREDENTIALS
    end

    def refresh_token? : Bool
      @grant_type == REFRESH_TOKEN
    end

    def valid? : Bool
      authorization_code? || client_credentials? || refresh_token?
    end

    def invalid? : Bool
      !valid?
    end

    def to_s(io : IO)
      io << @grant_type
    end

    def to_json(json)
      json.string(to_s)
    end

    def to_param : String
      to_s
    end

    def self.adapter
      Lucky
    end

    module Lucky
      include Avram::Type

      alias ColumnType = String

      def self.criteria(query : T, column) forall T
        Criteria(T, OauthGrantType).new(query, column)
      end

      def parse(value : Symbol)
        parse(value.to_s)
      end

      def parse(value : String)
        parse OauthGrantType.new(value)
      end

      def parse(value : OauthGrantType)
        if value.invalid?
          FailedCast.new
        else
          SuccessfulCast(OauthGrantType).new(value)
        end
      end

      def parse(values : Array)
        casts = values.map { |value| parse(value) }
        return FailedCast.new unless casts.all?(SuccessfulCast)

        SuccessfulCast(Array(OauthGrantType)).new(
          casts.map &.as(SuccessfulCast).value
        )
      end

      def to_db(value : OauthGrantType)
        value.to_s
      end

      def to_db(values : Array(OauthGrantType))
        PQ::Param.encode_array(values)
      end

      class Criteria(T, V) < String::Lucky::Criteria(T, V)
      end
    end
  end
end
