class Login < BaseModel
  include Shield::Login

  skip_default_columns
  primary_key id : Int64

  table :logins {}
end
