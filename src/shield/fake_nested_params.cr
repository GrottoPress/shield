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
          .transform_values(&.to_s)
      end
    end

    def nested?(key : String | Symbol) : Hash(String, String)
      params = @hash[key.to_s]?
      params.nil? ? Hash(String, String).new : params
    end

    def nested(key : String) : Hash(String, String)
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
  end
end
