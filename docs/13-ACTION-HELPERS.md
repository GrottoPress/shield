## Action Helpers

`Shield::Action` adds in the following helpers:

- `#current_login`:

    Returns the current login, or `nil` if the user is not logged in.

- `#current_login!`:

    Equivalent to `current_login.not_nil!`.

- `#current_user`:

    Returns the current logged-in user, or `nil` if the user is not logged in.

- `#current_user!`:

    Equivalent to `current_user.not_nil!`.

- `#logged_in?`:

    Returns true if current user is logged in.

- `#logged_out?`:

    Returns true if current user is **not** logged in. It is the inverse of `#logged_in?`

- `#previous_page_path`:

    Returns the previous page URL, retrieved from session rather than from request headers.

- `#remote_ip`:

    Returns the client's IP address as `Socket::IPAddress?`.
