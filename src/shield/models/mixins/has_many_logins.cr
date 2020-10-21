module Shield::HasManyLogins
  macro included
    has_many logins : Login
  end
end
