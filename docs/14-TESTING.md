## Testing

### Setting up

1. Require *Shield* spec:

   ```crystal
   # ->>> spec/spec_helper.cr

   # ...
   require "shield/spec"
   # ...
   ```

   This pulls in various types and helpers for specs.

1. Set up API client:

   ```crystal
   # ->>> spec/support/api_client.cr

   class ApiClient < Lucky::BaseHTTPClient
     def initialize
       super
       headers("Content-Type": "application/json")
     end

     # This creates a user for authentication purposes.
     #
     # Override this if you need to create the user some other way.
     # For instance, you may decide you do not want to create user
     # options when the user is created. Or you may want to create other
     # models associated with the user.
     #private def create_user(email : String, password : String)
     #  password_digest = BcryptHash.new(password).hash
     #  user = UserFactory.create &.email(email).password_digest(password_digest)
     #  UserOptionsFactory.create &.user_id(user.id)
     #end
   end
   ```

   *Shield* includes `Shield::HttpClient` in `Lucky::BaseHTTPClient`, which enables API and browser authentication in specs.

### Authentication

- Browser authentication

  ```crystal
  client = ApiClient.new

  # Creates a user and logs them in with an email and password.
  # You may optionally pass in `remote_ip` and `session`.
  client.browser_auth(email, password)

  # Logs in a user that is already created.
  # You may optionally pass in `remote_ip` and `session`.
  client.browser_auth(user, password)

  # Go ahead and make requests to routes with
  # the authenticated client.
  client.exec(CurrentUser::Show)
  ```

- API authentication with email and password

  ```crystal
  client = ApiClient.new

  # Creates a user and logs them in with an email and password.
  # You may optionally pass in `remote_ip`.
  client.api_auth(email, password)

  # Logs in a user that is already created.
  # You may optionally pass in `remote_ip`.
  client.api_auth(user, password)

  # Go ahead and make requests to routes with
  # the authenticated client.
  client.exec(Api::CurrentUser::Show)
  ```

- API Authentication with bearer tokens

  ```crystal
  client = ApiClient.new

  client.api_auth(bearer_token)

  # Go ahead and make requests to routes with
  # the authenticated client.
  client.exec(Api::CurrentUser::Show)
  ```

- Set cookie header from session

  ```crystal
  client = ApiClient.new
  session = Lucky::Session.new

  session.set(:one, "one")
  session.set(:two, "two")

  # Sets "Cookie" header from session
  client.set_cookie_from_session(session)

  # Go ahead and make requests.
  client.exec(Numbers::Show)
  ```

### Spec Helpers

- `#assert_valid(attribute)`:

  Asserts that the attribute is valid. Spec fails if the attribute has errors.

- `#assert_valid(attribute, text)`:

  Asserts that the attribute is valid, or has none of its errors containing `text`.

  ```crystal
  assert_valid(user_id, " required")
  ```

- `#assert_valid(operation, key)`:

  Asserts that the operation is valid, or has no error with key `key`. This is useful for custom errors.

  ```crystal
  assert_invalid(operation, :user)
  ```

- `#assert_valid(operation, key, text)`:

  Asserts that the operation is valid, or has no error with key `key`, or the error with key `key` has none of its values containing `text`. This is useful for custom errors.

  ```crystal
  assert_invalid(operation, :user, "not exist")
  ```

- `#assert_invalid(attribute)`:

  Asserts that the attribute is invalid. Spec fails if the attribute has **no** errors.

- `#assert_invalid(attribute, text)`:

  Asserts that the attribute is invalid, and has exactly one of its errors containing `text`.

  ```crystal
  assert_invalid(user_id, " required")
  ```

- `#assert_invalid(operation, key)`:

  Asserts that the operation is invalid, and has an error with key `key`. This is useful for custom errors.

  ```crystal
  assert_invalid(operation, :user)
  ```

- `#assert_invalid(operation, key, text)`:

  Asserts that the operation is invalid, and has an error with key `key`, which has exactly one of its values containing `text`. This is useful for custom errors.

  ```crystal
  assert_invalid(operation, :user, "not exist")
  ```

- `#params(**named_args)`:

   Useful for creating simple params:

   ```crystal
   SomeOperation.create!(params(email: "a@b.c", name: "abc"))
   ```

- `#nested_params(**named_args)`:

   Useful for creating nested params:

   ```crystal
   SomeOperation.create!(
     nested_params(user: {email: "a@b.c", name: "abc"}, school: {name: "xyz"})
   )
   ```
