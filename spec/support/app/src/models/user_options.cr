class UserOptions < BaseModel
  include Shield::UserOptions
  include Shield::LoginUserOptionsColumns
  include Shield::BearerLoginUserOptionsColumns
  include Shield::OauthClientUserOptionsColumns

  table :user_options {}
end
