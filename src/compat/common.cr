module Shield::BearerCredentials
  macro included
    @[Deprecated("Use `#password` instead")]
    def token : String
      password
    end
  end
end

module Shield::BearerToken
  macro included
    {% puts "Warning: Deprecated `Shield::BearerToken`. \
      Use `Shield::BearerCredentials` instead" %}

    include Shield::BearerCredentials
  end
end

struct BearerToken
  include Shield::BearerCredentials
end
