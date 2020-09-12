class Login < BaseModel
  include Shield::Login

  table :logins {}
end
