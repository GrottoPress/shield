## Configuration

*Shield* uses *Habitat*, which comes bundled with *Lucky*, for configuration.

```crystal
# ->>> config/shield.cr

Shield.configure do |settings|
  # The cost to apply to bcrypt hashes
  settings.bcrypt_cost = Lucky::Env.production? ? 12 : 4

  # How long should email confirmation last before it expires?
  settings.email_confirmation_expiry = 1.hour

  # How long should a login last before it expires?
  settings.login_expiry = 24.hours

  # Required minimum length of password
  settings.password_min_length = 12

  # Require lowercase letter in password?
  settings.password_require_lowercase = true

  # Require uppercase letter in password?
  settings.password_require_uppercase = true

  # Require number in password?
  settings.password_require_number = true

  # Require special character in password?
  settings.password_require_special_char = true

  # How long should a password reset last before it expires?
  settings.password_reset_expiry = 30.minutes
end
```
