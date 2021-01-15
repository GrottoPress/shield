## Login

1. Configure:

   ```crystal
   # ->>> config/shield.cr

   Shield.configure do |settings|
     # ...
     # How long should a login last before it is expired?
     # The login will unconditionally expire after this time span.
     #settings.login_expiry = 24.hours
     #
     # How long can a login remain idle before it is timed out.
     #settings.login_idle_timeout = 30.minutes
     # ...
   end
   ```

1. Set up models:

   ```crystal
   # ->>> src/models/login.cr

   class Login < BaseModel
     # ...
     include Shield::Login

     table :logins do
       # You may add more columns here
     end
     # ...
   end
   ```

   `Shield::Login` adds the following columns:
   
   - `ended_at : Time?`
   - `ip_address : String`
   - `started_at : Time`
   - `token_digest : String`

   It removes *Lucky*'s default `created_at : Time` and `update_at : Time` columns.

   You may add other columns and associations specific to your application.

1. Set up the migration:

   ```crystal
   # ->>> db/migrations/XXXXXXXXXXXXXX_create_logins.cr

   class CreateLogins::VXXXXXXXXXXXXXX < Avram::Migrator::Migration::V1
     def migrate
       create table_for(Login) do
         # ...
         primary_key id : Int64

         add_belongs_to user : User, on_delete: :cascade

         add token_digest : String
         add ip_address : String
         add started_at : Time
         add ended_at : Time?
         # ...
       end
     end

     def rollback
       drop table_for(Login)
     end
   end
   ```

   Add any columns you added to the model here.

1. Set up operations:

   All operations are already set up. You may reopen an operation to add new functionality.

   ```crystal
   # ->>> src/operations/log_user_in.cr

   class LogUserIn < Login::SaveOperation
     # ...
     # By default, *Shield* sets the `ended_at` time here, using
     # the expiry setting above.
     #
     # Use this, if you would like to never expire logins,
     # irrespective of the expiry setting.
     #include Shield::NeverExpires
     # ...
   end
   ```

   `LogUserIn` receives `email` and `password` parameters, and creates a login entry with a unique ID and hashed token in the database.

   For a client to be considered logged in, it must present a matching login ID and token from session.

   ---
   ```crystal
   # ->>> src/operations/log_user_out.cr

   class LogUserOut < Login::SaveOperation
     # ...
   end
   ```

   `LogUserOut` deletes session values related to the login, and updates the relevant columns in the database to mark the login as inactive.

   ---
   ```crystal
   # ->>> src/operations/delete_login.cr

   class DeleteLogin < Avram::Operation
     # ...
   end
   ```

   `DeleteLogin` actually deletes a given login from the database. Use this instead of `LogUserOut` if you intend to actually delete logins, rather than mark them as inactive.

1. Set up actions:

   ```crystal
   # ->>> src/actions/browser_action.cr

   abstract class BrowserAction < Lucky::Action
     # ...
     # If you are worried about users on mobile, you may want
     # to disable pinning a login to its IP address
     #skip :pin_login_to_ip_address

     # What to do if user is **not** logged in
     # but the action requires user to be logged in.
     #
     #def do_require_logged_in_failed
     #  flash.keep.failure = "You are not logged in"
     #  redirect to: CurrentLogin::New
     #end

     # What to do if user is logged in but the action
     # requires user to **not** be logged in.
     #
     #def do_require_logged_out_failed
     #  flash.keep.info = "You are already logged in"
     #  redirect_back fallback: CurrentUser::Show
     #end

     # What to do when a logged in user's IP address changes, if the
     # action requires the user's IP to match the IP they used to
     # log in.
     #
     #def do_pin_login_to_ip_address_failed
     #  flash.keep.failure = "Your IP address has changed. Please log in again."
     #  redirect to: CurrentLogin::New
     #end

     # What to do when a login has been idle for as long as defined in
     # `Shield.settings.login_idle_timeout`, if the action enforces login timeouts.
     #
     #def do_enforce_login_idle_timeout_failed
     #  flash.keep.failure = "Your login timed out"
     #  redirect to: CurrentLogin::New
     #end
     # ...
   end
   ```

   ---
   ```crystal
   # ->>> src/actions/logins/new.cr

   class CurrentLogin::New < BrowserAction
     # ...
     include Shield::CurrentLogin::New

     get "/login" do
       operation = LogUserIn.new(remote_ip: remote_ip)
       html NewPage, operation: operation
     end
     # ...
   end
   ```

   You may need to add `CurrentLogin::NewPage` in `src/pages/logins/new_page.cr`, containing your user login form.

   The form should be `POST`ed to `CurrentLogin::Create`, with the following parameters:

   - `email : String`
   - `password : String`

   If you choose to show operation errors on this page, skip `email` and `password` errors. You do not want to leak information as to which of the supplied credentials were incorrect.

   You may skip this action if building an API.

   ---
   ```crystal
   # ->>> src/actions/logins/create.cr

   class CurrentLogin::Create < BrowserAction
     # ...
     include Shield::CurrentLogin::Create

     post "/login" do
       run_operation
     end

     # What to do if `run_operation` succeeds
     #
     #def do_run_operation_succeeded(operation, login)
     #  flash.keep.success = "Successfully logged in"
     #  redirect_back fallback: CurrentUser::Show
     #end

     # What to do if `run_operation` fails
     #
     #def do_run_operation_failed(operation)
     #  flash.failure = "Invalid email or password"
     #  html NewPage, operation: operation
     #end
     # ...
   end
   ```

   ---
   ```crystal
   # ->>> src/actions/logins/destroy.cr

   class CurrentLogin::Destroy < BrowserAction
     # ...
     # By default, *Shield* marks the login as inactive,
     # without deleting it.
     #
     # To delete it, use `Shield::CurrentLogin::Delete` instead.
     include Shield::CurrentLogin::Destroy

     delete "/login" do
       run_operation
     end

     # What to do if `run_operation` succeeds
     #
     #def do_run_operation_succeeded(operation, login)
     #  flash.keep.success = "You logged out"
     #  redirect to: New
     #end

     # What to do if `run_operation` fails
     #
     #def do_run_operation_failed(operation)
     #  flash.keep.failure = "Something went wrong"
     #  redirect_back fallback: CurrentUser::Show
     #end
     # ...
   end
   ```
