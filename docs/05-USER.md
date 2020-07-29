## User

1. Set up the model:

   ```crystal
   # ->>> src/models/user.cr

   class User < BaseModel
     # ...
     include Shield::User

     table :users do
       # You may add more columns here
     end
     # ...
   end
   ```

   `Shield::User` adds the following columns:
   
   - `email : String`
   - `password_hash : String`
   
   ...and sets up the relevant associations with other *Shield* models.

   You may add other columns and associations specific to your application.

1. Set up the migration:

   ```crystal
   # ->>> db/migrations/XXXXXXXXXXXXXX_create_users.cr

   class CreateUsers::VXXXXXXXXXXXXXX < Avram::Migrator::Migration::V1
     def migrate
       create table_for(User) do
         # ...
         primary_key id : Int64

         add_timestamps

         add email : String, unique: true
         add password_hash : String
         # ...
       end
     end

     def rollback
       drop table_for(User)
     end
   end
   ```

   Add any columns you added to the model here.

1. Set up operations:

   ```crystal
   # ->>> src/operations/register_currrent_user.cr

   class RegisterCurrentUser < User::SaveOperation
     # ...
     include Shield::RegisterCurrentUser
     # ...
   end
   ```

   There's also `Shield::RegisterUser`, but that is reserved for saving users in other scenarios, such as an admin adding a new user.

   `Shield::RegisterCurrentUser` is what should be used for user self-registration.

   `Shield::RegisterCurrentUser` saves `email`, `password` and user options. If you added other columns and associations to the model, you may have to add callbacks for dealing with those.

   ---
   ```crystal
   # ->>> src/operations/update_currrent_user.cr

   class UpdateCurrentUser < User::SaveOperation
     # ...
     include Shield::UpdateCurrentUser
     # ...
   end
   ```

   `Shield::UpdateCurrentUser` is similar to `Shield::RegisterCurrentUser`, except it *updates* an existing user rather than create a new one.

   There's also `Shield::UpdateUser` as the *update* counterpart to `Shield::RegisterUser`

   ---
   ```crystal
   # ->>> src/operations/verify_user.cr

   class VerifyUser < Avram::BasicOperation
     # ...
     include Shield::VerifyUser
     # ...
   end
   ```

   `Shield::VerifyUser` is a basic (non-database) operation that authenticates a user. It accepts `email : String` and an optional `password : String`.

1. Set up actions:

   ```crystal
   # ->>> src/actions/current_user/new.cr

   class CurrentUser::New < BrowserAction
     # ...
     include Shield::CurrentUser::New

     get "/sign-up" do
       html NewPage
     end
     # ...
   end
   ```

   You may need to add `CurrentUser::NewPage` in `src/pages/current_user/new_page.cr`, containing your user registration form.

   The form should be `POST`ed to `CurrentUser::Create`, with the following parameters:

   - `email : String`
   - `password : String`
   - `password_confirmation : String`

   You may skip this action if building an API.

   ---
   ```crystal
   # ->>> src/actions/current_user/create.cr

   class CurrentUser::Create < BrowserAction
     # ...
     include Shield::CurrentUser::Create

     post "/sign-up" do
       save_current_user
     end

     # What to do if `save_current_user` succeeds
     #
     #private def success_action(operation, user)
     #  flash.success = "User added successfully"
     #  redirect to: New
     #end

     # What to do if `save_current_user` fails
     #
     #private def failure_action(operation)
     #  flash.failure = "Could not add user"
     #  html NewPage, operation: operation
     #end
     # ...
   end
   ```
