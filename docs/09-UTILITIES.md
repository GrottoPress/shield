## Utilities

*Utilities* are (plain old *Crystal*) objects with domain-specific business logic. You may know them as non-database models. *Shield* calls them *Utilities* to differentiate them from database-backed models.

1. `LoginSession`

   ```crystal
   # ->>> src/utilities/login_session.cr

   class LoginSession # Or `struct ...`
     # ...
     include Shield::LoginSession
     # ...
   end
   ```

   `Shield::LoginSession` is a wrapper around *Lucky* sessions that deals with session keys and values for logins, and handles verification of login tokens retrieved from session.

1. `PageUrlSession`:

   ```crystal
   # ->>> src/utilities/previous_page_session.cr

   class PageUrlSession # Or `struct ...`
     # ...
     include Shield::PageUrlSession
     # ...
   end
   ```

   `Shield::PageUrlSession` is a wrapper around *Lucky* sessions that deals with session keys and values for the page previous to the current page.

1. `PasswordResetSession`:

   ```crystal
   # ->>> src/utilities/password_reset_session.cr

   class PasswordResetSession # Or `struct ...`
     # ...
     include Shield::PasswordResetSession
     # ...
   end
   ```

   `Shield::PasswordResetSession` is a wrapper around *Lucky* sessions that deals with session keys and values for password resets, and handles verification of password reset tokens retrieved from session.

1. `ReturnUrlSession`:

   ```crystal
   # ->>> src/utilities/previous_page_session.cr

   class ReturnUrlSession # Or `struct ...`
     # ...
     include Shield::ReturnUrlSession
     # ...
   end
   ```

   `Shield::ReturnUrlSession` is a wrapper around *Lucky* sessions that deals with session keys and values for the URL to return to.

   `#redirect_back` checks for this session value first, and redirects to it if present.

   *Shield* throws away the `allow_external` parameter in `#redirect_back`, so the only way to return to an external URL is to set the external URL thus: `ReturnUrlSession.new(session).set("http://external.url")`.
