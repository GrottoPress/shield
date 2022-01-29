module Shield
  Habitat.create do
    setting bearer_login_expiry : Time::Span? = 90.days
    setting email_confirmation_expiry : Time::Span = 1.hour
    setting login_expiry : Time::Span? = 24.hours
    setting login_idle_timeout : Time::Span? = 30.minutes
    setting password_min_length : Int32 = 12
    setting password_require_lowercase : Bool = true
    setting password_require_uppercase : Bool = true
    setting password_require_number : Bool = true
    setting password_require_special_char : Bool = true
    setting password_reset_expiry : Time::Span = 30.minutes

    macro finished
      {% if Lucky::Action.all_subclasses
        .map(&.stringify)
        .includes?("EmailConfirmations::Show") %}

        setting email_confirmation_url : String -> String =
          ->(token : String) do
            ::EmailConfirmations::Show.with(token: token).url
          end
      {% else %}
        setting email_confirmation_url : String -> String
      {% end %}

      {% if Lucky::Action.all_subclasses
        .map(&.stringify)
        .includes?("PasswordResets::Show") %}

        setting password_reset_url : String -> String = ->(token : String) do
          ::PasswordResets::Show.with(token: token).url
        end
      {% else %}
        setting password_reset_url : String -> String
      {% end %}
    end
  end
end
