## Testing

1. Set up API client

   ```crystal
   # ->>> spec/support/api_client.cr

   class ApiClient < Lucky::BaseHTTPClient
     include Shield::HttpClient

     def initialize
       super
       headers("Content-Type": "application/json")
     end
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
     client.exec(CurrentUser::Show)
     ```

   - API Authentication with bearer tokens

     ```crystal
     client = ApiClient.new

     # Creates a user and logs them in with an email and password
     # You may optionally pass in `remote_ip` and `session`
     client.api_auth(bearer_token)

     # Go ahead and make requests to routes with
     # the authenticated client.
     client.exec(CurrentUser::Show)
     ```
