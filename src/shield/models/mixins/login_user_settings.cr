module Shield::LoginUserSettings
  macro included
    getter? login_notify : Bool = true

    def login_notify
      login_notify?
    end
  end
end
