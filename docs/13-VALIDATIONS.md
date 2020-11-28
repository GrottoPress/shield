## Validations

*Shield* defines custom validation helpers, in addition to what *Avram* provides:

- `.validate_email`:

  Checks that the given attributes are valid email addresses.

- `.validate_domain`:

  Checks that the given attributes are valid domains.

- `.validate_domain_label`:

  Checks that the given attributes are valid domains labels (such as *example* in 'example.com').

- `.validate_exists_by_id`:

  Checks that the given attribute is a valid ID of another model.

  #### Examples:

  ```crystal
  validate_exists_by_id user_id, query: UserQuery.new, message: "does not exist"
  validate_exists_by_id post_id, query: PostQuery.new
  ```

- `.validate_http_url`:

  Checks that given attributes are valid HTTP URLs.

- `.validate_ip`:

  Checks that the given attributes are valid IP addresses.

- `.validate_ip4`:

  Checks that the given attributes are valid IPv4 addresses.

- `.validate_ip6`:

  Checks that the given attributes are valid IPv6 addresses.

- `.validate_name`:

  Checks that the given attributes are valid names.

- `.validate_negative_number`:

  Checks that the given attributes are negative numbers.

- `.validate_positive_number`:

  Checks that the given attributes are positive numbers.

- `.validate_slug`:

  Checks that the given attributes are valid URL slugs.

- `.validate_url`:

  Checks that the given attributes are valid URLs.

- `.validate_username`:

  Checks that the given attributes are valid usernames.

- `.validate_not_pwned`:

  Checks the given password attributes to be sure they do not appear in any known data breach. This uses the [Pwned Passwords](https://haveibeenpwned.com/Passwords) API.

  #### Setup

  1. Set up utilities:

     ```crystal
     class PwnedPasswords # or `struct`
       include Shield::PwnedPasswords
     end
     ```

  #### Examples:

  ```crystal
  validate_not_pwned password, message: "appears in a known data breach"
  ```

  By default, if the remote API call fails, validation fails with a default message. You may customize this message by passing a `remote_fail` argument:

  ```crystal
  validate_not_pwned password, remote_fail: "validation failed. Try again or contact support."
  ```

  If you would rather have validation **pass** if the remote API call fails, set `remote_fail` to `nil`:

  ```crystal
  validate_not_pwned password, remote_fail: nil
  ```
