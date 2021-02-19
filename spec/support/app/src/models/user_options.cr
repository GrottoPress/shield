class UserOptions < BaseModel
  include Shield::UserOptions
  include Shield::LoginUserOptionsColumns
  include Shield::BearerLoginUserOptionsColumns

  table :user_options {}
end
