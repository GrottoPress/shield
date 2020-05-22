module Shield
  Habitat.create do
    setting base_uri : String = Lucky::RouteHelper.settings.base_uri
    setting login_expiry : Time::Span = 30.days
    setting password_min_length : Int32 = 12
    setting password_notify_change : Bool = true
    setting password_require_lowercase : Bool = true
    setting password_require_uppercase : Bool = true
    setting password_require_number : Bool = true
    setting reset_token_expiry : Time::Span = 30.minutes
  end
end
