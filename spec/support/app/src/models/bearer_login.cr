class BearerLogin < BaseModel
  include Shield::BearerLogin

  skip_default_columns
  primary_key id : Int64

  table :bearer_logins {}
end
