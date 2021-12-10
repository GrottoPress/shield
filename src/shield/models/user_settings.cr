module Shield::UserSettings
  macro included
    include Lucille::JSON

    getter? password_notify : Bool = true

    def password_notify
      password_notify?
    end
  end
end
