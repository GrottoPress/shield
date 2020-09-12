class ResetPassword < User::SaveOperation
  include Shield::ResetPassword
end
