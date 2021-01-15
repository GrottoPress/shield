## General Setup

1. Configure:

   *Shield* uses *Habitat*, which comes bundled with *Lucky*, for configuration.

   ---
   ```crystal
   # ->>> config/shield.cr

   Shield.configure do |settings|
     # ...
     # The cost to apply to bcrypt hashes
     settings.bcrypt_cost = Lucky::Env.production? ? 12 : 4

     # Required minimum length of password
     settings.password_min_length = Lucky::Env.production? ? 12 : 4

     # Require lowercase letter in password?
     settings.password_require_lowercase = Lucky::Env.production?

     # Require uppercase letter in password?
     settings.password_require_uppercase = Lucky::Env.production?

     # Require number in password?
     settings.password_require_number = Lucky::Env.production?

     # Require special character in password?
     settings.password_require_special_char = Lucky::Env.production?
     # ...
   end
   ```
