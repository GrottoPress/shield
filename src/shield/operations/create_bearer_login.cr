module Shield::CreateBearerLogin # BearerLogin::SaveOperation
  macro included
    permit_columns :name, :scopes

    include Lucille::SetUserIdFromUser
    include Lucille::Activate
    include Shield::SetToken

    before_save do
      set_inactive_at
    end

    include Shield::ValidateBearerLogin

    {% if Avram::Model.all_subclasses.find(&.name.== :UserOptions.id) %}
      include Shield::NotifyBearerLogin
    {% elsif Lucille::JSON.includers.find(&.name.== :UserSettings.id) %}
      include Shield::NotifyBearerLoginIfSet
    {% end %}

    private def set_inactive_at
      Shield.settings.bearer_login_expiry.try do |expiry|
        active_at.value.try { |value| inactive_at.value = value + expiry }
      end
    end
  end
end
