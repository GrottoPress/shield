require "../compat/common"

abstract class BaseModel < Avram::Model
  include Shield::Model
end

module Lucky::HTMLPage
  include Shield::LoginHelpers
end

struct PageUrlSession
  include Shield::PageUrlSession
end

struct ReturnUrlSession
  include Shield::ReturnUrlSession
end

struct BearerScope
  include Shield::BearerScope
end

struct BcryptHash
  include Shield::BcryptHash
end

struct Sha256Hash
  include Shield::Sha256Hash
end
