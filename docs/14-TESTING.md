## Testing

1. Set up API client:

   ```crystal
   # ->>> spec/support/api_client.cr

   class ApiClient < Lucky::BaseHTTPClient
     include Shield::HttpClient

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
     #  user = UserBox.create &.email(email).password_digest(password_digest)
     #  UserOptionsBox.create &.user_id(user.id)
     #end
   end
   ```

   `Shield::HttpClient` enables API and browser authentication in specs:

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

1. Set up fake params:

   ```crystal
   # ->>> spec/support/fake_nested_params.cr

   class FakeNestedParams
     include Shield::FakeNestedParams
   end
   ```

   `Shield::FakeNestedParams` allows creating nested params for tests.

   ---
   ```crystal
   # ->>> spec/spec_helper.cr

   def params(**named_args)
     Avram::Params.new named_args.to_h
       .transform_keys(&.to_s)
       .transform_values &.to_s
   end

   def nested_params(**named_args)
     FakeNestedParams.new(**named_args)
   end
   ```

   For simple params:

   ```crystal
   SomeOperation.create!(params(email: "a@b.c", name: "abc"))
   ```

   For nested params:

   ```crystal
   SomeOperation.create!(
     nested_params(user: {email: "a@b.c", name: "abc"}, school: {name: "xyz"})
   )
   ```
