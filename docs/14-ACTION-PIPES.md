## Action Pipes

*Shield* ships with the following pipes active, by default, on the relevant actions:

- `#check_authorization`:

  Checks authorization to grant or deny access to a route.

- `#disable_caching`:

  Sets the HTTP `Cache-Control` header to disable caching.

- `#pin_login_to_ip_address`:

  Logs out the current user if their IP address changed from the one they originally used to log in.

- `#pin_password_reset_to_ip_address`:

  Invalidates a password reset if the requester's IP address differs from the one they originally used to request the password reset.

- `#require_logged_in`:

  Enforces logins. It requires that a user be logged in to access a route.

- `#require_logged_out`:

  Requires a user to be logged out to access a route.

- `#set_no_referrer_policy`:

  Sets the HTTP `Referrer-Policy` header to `no-referrer`.

- `#set_previous_page_url`:

  Sets the current URL in session as the previous page URL to be used by the next action. *Shield* overrides `#redirect_back` to use this URL, instead of the value from the HTTP referrer header that *Lucky* uses.

Because `#require_logged_in` and `#require_logged_out` are active at the same time, you are required to explicitly skip at least one of them in your actions.
