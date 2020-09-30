## Login

1. Set up the model

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
   - `status : Login::Status`
   - `token_digest : String`
   
   ...and sets up a one-to-many association with the `User` model.

   It removes *Lucky*'s default `created_at : Time` and `update_at : Time` columns.

   You may add other columns and associations specific to your application.

1. Set up the migration:

   ```crystal
   # ->>> db/migrations/XXXXXXXXXXXXXX_create_login.cr

   class CreateLogin::VXXXXXXXXXXXXXX < Avram::Migrator::Migration::V1
     def migrate
       create table_for(Login) do
         # ...
         primary_key id : Int64

         add_belongs_to user : User, on_delete: :cascade

         add token_digest : String
         add ip_address : String
         add status : String
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

   ```crystal
   # ->>> src/operations/log_user_in.cr

   class LogUserIn < Login::SaveOperation
     # ...
     include Shield::LogUserIn
     # ...
   end
   ```

   `Shield::LogUserIn` receives `email` and `password` parameters, and creates a login entry with a unique ID and hashed token in the database.

   For a client to be considered logged in, it must present a matching login ID and token from session.

   ---
   ```crystal
   # ->>> src/operations/log_user_out.cr

   class LogUserOut < Login::SaveOperation
     # ...
     include Shield::LogUserOut
     # ...
   end
   ```

   `Shield::LogUserOut` deletes session values related to the login, and updates the relevant columns in the database to mark the login as inactive.

1. Set up actions:

   ```crystal
   # ->>> src/actions/logins/new.cr

   class Logins::New < BrowserAction
     # ...
     include Shield::Logins::New

     get "/login" do
       html NewPage
     end
     # ...
   end
   ```

   You may need to add `Logins::NewPage` in `src/pages/logins/new_page.cr`, containing your user login form.

   The form should be `POST`ed to `Logins::Create`, with the following parameters:

   - `email : String`
   - `password : String`

   If you choose to show operation errors on this page, skip `email` and `password` errors. You do not want to leak information as to which of the supplied credentials were incorrect.

   You may skip this action if building an API.

   ---
   ```crystal
   # ->>> src/actions/logins/create.cr

   class Logins::Create < BrowserAction
     # ...
     include Shield::Logins::Create

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

   class Logins::Destroy < BrowserAction
     # ...
     include Shield::Logins::Destroy

     delete "/login" do
       run_operation
     end

     # What to do if `run_operation` succeeds
     #
     #def do_run_operation_succeeded(operation, login)
     #  flash.keep.success = "Logged out. See ya!"
     #  redirect to: New
     #end

     # What to do if `run_operation` fails
     #
     #def do_run_operation_failed(operation, login)
     #  flash.keep.failure = "Something went wrong"
     #  redirect_back fallback: CurrentUser::Show
     #end
     # ...
   end
   ```
