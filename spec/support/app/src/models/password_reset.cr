class PasswordReset < BaseModel
  include Shield::PasswordReset

  table :password_resets {}
end
