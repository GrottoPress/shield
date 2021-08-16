module Shield::UserSettings
  macro included
    include JSON::Serializable

    property? password_notify : Bool = true

    def password_notify
      password_notify?
    end
  end
end
