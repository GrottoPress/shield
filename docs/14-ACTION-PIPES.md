## Action Pipes

*Shield* ships with the following pipes:

- `#pin_login_to_ip_address` (Enabled by default):

  Logs out the current user if their IP address changed from the one they originally used to log in.

- `#pin_password_reset_to_ip_address` (Enabled by default)

  Invalidates a password reset if the requester's IP address differs from the one they originally used to request the password reset.
