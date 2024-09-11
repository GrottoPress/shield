module Shield::User
  macro included
    # include Shield::HasManyBearerLogins
    # include Shield::HasManyEmailConfirmations
    # include Shield::HasManyLogins
    # include Shield::HasManyOauthClients
    # include Shield::HasManyOauthGrants
    # include Shield::HasManyPasswordResets

    # include Shield::HasOneUserOptions
    # #include Shield::UserSettingsColumn

    column email : String
    column password_digest : String
  end
end
