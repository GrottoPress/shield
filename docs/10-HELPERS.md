## Helpers

At the core of *Lucky*'s philosophy is keeping business logic out of database models, and into operations. This works great for operation-specific business logic.

There may be cases where specific functionality do not fit into an operation, or fit into more than one operation. The convention is to use mixins (modules), and `include` them wherever they are needed.

*Shield* uses helpers instead. *Helpers* are modules with methods that are called directly, as namespaced module methods, rather than included in another type.

*Shield*'s approach ensures such methods really stay in one place, rather than duplicated in multiple types. It also avoids including methods in a type that may never be used, or having one method per mixin (module) as an attempt to avoid the former.

1. `CryptoHelper`

   ```crystal
   # ->>> src/helpers/crypto_helper.cr

   module CryptoHelper
     # ...
     extend Shield::CryptoHelper
     # ...
   end
   ```

   `Shield::CryptoHelper` contains methods for generating, hashing and verifying passwords, and tokens.

1. `LoginHelper`:

   ```crystal
   # ->>> src/helpers/login_helper.cr

   module LoginHelper
     # ...
     extend Shield::LoginHelper
     # ...
   end
   ```

   `Shield::LoginHelper` contains login-related helper methods.

1. `PasswordResetHelper`:

   ```crystal
   # ->>> src/helpers/password_reset_helper.cr

   module PasswordResetHelper
     # ...
     extend Shield::PasswordResetHelper
     # ...
   end
   ```

   `Shield::PasswordResetHelper` contains helper methods related to password resets.

1. `UserHelper`:

   ```crystal
   # ->>> src/helpers/user_helper.cr

   module UserHelper
     # ...
     extend Shield::UserHelper
     # ...
   end
   ```

   `Shield::UserHelper` contains helper methods related to the user model.
