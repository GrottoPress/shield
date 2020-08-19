## Utilities

*Utilities* are (plain old *Crystal*) objects with domain-specific business logic. You may know them as non-database models. *Shield* calls them *Utilities* to differentiate them from database-backed models.

1. `BaseSession`

   ```crystal
   # ->>> src/utilities/base_session.cr

   abstract class BaseSession # Or `abstract struct ...`
     # ...
     include Shield::Session
     # ...
   end
   ```

   `Shield::BaseSession` serves as the base type for all session wrappers.

1. `LoginSession`

   ```crystal
   # ->>> src/utilities/login_session.cr

   class LoginSession < BaseSession # Or `struct ...`
     # ...
     include Shield::LoginSession
     # ...
   end
   ```

   `Shield::LoginSession` is a wrapper around *Lucky* sessions that deals with session keys and values for logins, and handles verification of login tokens retrieved from session.

1. `PasswordResetSession`:

   ```crystal
   # ->>> src/utilities/password_reset_session.cr

   class PasswordResetSession < BaseSession # Or `struct ...`
     # ...
     include Shield::PasswordResetSession
     # ...
   end
   ```

   `Shield::PasswordResetSession` is a wrapper around *Lucky* sessions that deals with session keys and values for password resets, and handles verification of password reset tokens retrieved from session.

1. `PreviousPageSession`:

   ```crystal
   # ->>> src/utilities/previous_page_session.cr

   class PreviousPageSession < BaseSession # Or `struct ...`
     # ...
     include Shield::PreviousPageSession
     # ...
   end
   ```

   `Shield::PreviousPageSession` is a wrapper around *Lucky* sessions that deals with session keys and values for the page previous to the current page.
