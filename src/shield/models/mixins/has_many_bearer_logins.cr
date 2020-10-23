module Shield::HasManyBearerLogins
  macro included
    has_many bearer_logins : BearerLogin
  end
end
