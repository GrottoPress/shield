require "../../config/types"

class UserQuery < User::BaseQuery
  include Shield::UserQuery
end
