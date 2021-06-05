module Shield::FakeNestedParams
  macro included
    include Avram::Paramable

    def initialize(@hash : Hash(String, Hash(String, String)))
    end

    def initialize(**params)
      @hash = Hash(String, Hash(String, String)).new

      params.to_h.each do |key, value|
        @hash[key.to_s] = value.to_h
          .transform_keys(&.to_s)
          .transform_values { |value| self.class.value_to_s(value) }
      end
    end

    def nested?(key : String | Symbol) : Hash(String, String)
      params = @hash[key.to_s]?
      params.nil? ? Hash(String, String).new : params
    end

    def nested(key) : Hash(String, String)
      nested?(key)
    end

    def many_nested?(key : String) : Array(Hash(String, String))
      raise "Not implemented"
    end

    def many_nested(key : String) : Array(Hash(String, String))
      raise "Not implemented"
    end

    def get?(key)
      raise "Not implemented"
    end

    def get(key)
      raise "Not implemented"
    end

    def nested_file?(key)
      raise "Not implemented"
    end

    def nested_file(key)
      raise "Not implemented"
    end

    def self.value_to_s(value)
      case value
      when Time
        value.to_utc.to_s("%Y-%m-%dT%H:%M:%S")
      else
        value.to_s
      end
    end
  end
end
