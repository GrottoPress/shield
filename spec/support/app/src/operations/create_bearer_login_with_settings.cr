class CreateBearerLoginWithSettings < BearerLogin::SaveOperation
  include Shield::CreateBearerLogin
  include Shield::NotifyBearerLoginIfSet
end
