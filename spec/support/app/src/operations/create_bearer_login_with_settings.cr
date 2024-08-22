class CreateBearerLoginWithSettings < BearerLogin::SaveOperation
  permit_columns :name, :scopes

  include Shield::NotifyBearerLoginIfSet
  include Lucille::SetUserIdFromUser
  include Lucille::Activate
  include Shield::SetToken

  before_save do
    set_inactive_at
  end

  include Shield::ValidateBearerLogin

  private def set_inactive_at
    Shield.settings.bearer_login_expiry.try do |expiry|
      active_at.value.try { |value| inactive_at.value = value + expiry }
    end
  end
end
