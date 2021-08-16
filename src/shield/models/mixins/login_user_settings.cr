module Shield::LoginUserSettings
  macro included
    property? login_notify : Bool = true

    def login_notify
      login_notify?
    end
  end
end
