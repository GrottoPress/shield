module Shield::BearerToken
  macro included
    @[Deprecated("Use `#password` instead")]
    def token : String
      password
    end
  end
end
