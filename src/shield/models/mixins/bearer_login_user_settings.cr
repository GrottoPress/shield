module Shield::BearerLoginUserSettings
  macro included
    getter? bearer_login_notify : Bool = true

    def bearer_login_notify
      bearer_login_notify?
    end
  end
end
