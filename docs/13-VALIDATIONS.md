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
