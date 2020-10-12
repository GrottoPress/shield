class BearerLogin < BaseModel
  include Shield::BearerLogin

  table :bearer_logins {}
end
