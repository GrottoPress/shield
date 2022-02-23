## General Setup

1. Configure:

   *Shield* uses *Habitat*, which comes bundled with *Lucky*, for configuration.

   ---
   ```crystal
   # ->>> config/shield.cr

   Shield.configure do |settings|
     # ...
     # Required minimum length of password
     settings.password_min_length = LuckyEnv.production? ? 12 : 4

     # Require lowercase letter in password?
     settings.password_require_lowercase = LuckyEnv.production?

     # Require uppercase letter in password?
     settings.password_require_uppercase = LuckyEnv.production?

     # Require number in password?
     settings.password_require_number = LuckyEnv.production?

     # Require special character in password?
     settings.password_require_special_char = LuckyEnv.production?
     # ...
   end
   ```

1. Set up base types:

   ---
   ```crystal
   # ->>> src/models/user.cr

   abstract class BaseModel < Avram::Model
     # ...
     include Shield::Model
     # ...
   end
   ```
