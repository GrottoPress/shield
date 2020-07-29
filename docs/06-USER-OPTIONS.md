## User Options

1. Set up the model:

   ```crystal
   # ->>> src/models/user_options.cr

   class UserOptions < BaseModel
     # ...
     include Shield::UserOptions

     table :user_options do
       # You may add more columns here
     end
     # ...
   end
   ```

   `Shield::UserOptions` adds the following columns:
   
   - `login_notify : Bool`
   - `password_notify : Bool`
   
   ...and sets up a one-to-one association with the `User` model.

   You may add other columns and associations specific to your application.

1. Set up the migration:

   ```crystal
   # ->>> db/migrations/XXXXXXXXXXXXXX_create_user_options.cr

   class CreateUserOptions::VXXXXXXXXXXXXXX < Avram::Migrator::Migration::V1
     def migrate
       create table_for(UserOptions) do
         # ...
         primary_key id : Int64

         add_timestamps
         add_belongs_to user : User, on_delete: :cascade

         add login_notify : Bool
         add password_notify : Bool
         # ...
       end

       # This sets a "UNIQUE" constraint on the foreign key (user_id)
       execute <<-SQL
       ALTER TABLE #{table_for(UserOptions)} ADD CONSTRAINT
       #{table_for(UserOptions)}_user_id_unique UNIQUE (user_id);
       SQL
     end

     def rollback
       drop table_for(UserOptions)
     end
   end
   ```

   Add any columns you added to the model here.

1. Set up operations:

   ```crystal
   # ->>> src/operations/save_user_options.cr

   class SaveUserOptions < UserOptions::SaveOperation
     # ...
     include Shield::SaveUserOptions
     # ...
   end
   ```

   `Shield::SaveUserOptions` saves `login_notify` and `password_notify`. If you added other columns and associations to the model, you may have to add callbacks for dealing with those.

1. Set up actions:

   User options do not have its own actions, since it is an extension of the `User` model in its own table.

   Operations and actions related to the `User` model already take care of saving user options.

   User edit forms, are therefore, required to include user options parameters:

   - `login_notify : Bool`
   - `password_notify : Bool`
