module Shield::Api::OauthPermissions::Delete
  macro included
    {% puts "Warning: Deprecated `Shield::Api::OauthPermissions::Delete`. \
      Use `Shield::Api::CurrentUser::OauthPermissions::Delete` instead" %}

    include Shield::Api::CurrentUser::OauthPermissions::Destroy
  end
end

module Shield::Api::OauthPermissions::Destroy
  macro included
    {% puts "Warning: Deprecated `Shield::Api::OauthPermissions::Destroy`. \
      Use `Shield::Api::CurrentUser::OauthPermissions::Destroy` instead" %}

    include Shield::Api::CurrentUser::OauthPermissions::Destroy
  end
end

module Shield::OauthPermissions::Delete
  macro included
    {% puts "Warning: Deprecated `Shield::OauthPermissions::Delete`. \
      Use `Shield::CurrentUser::OauthPermissions::Delete` instead" %}

    include Shield::CurrentUser::OauthPermissions::Destroy
  end
end

module Shield::OauthPermissions::Destroy
  macro included
    {% puts "Warning: Deprecated `Shield::OauthPermissions::Destroy`. \
      Use `Shield::CurrentUser::OauthPermissions::Destroy` instead" %}

    include Shield::CurrentUser::OauthPermissions::Destroy
  end
end
