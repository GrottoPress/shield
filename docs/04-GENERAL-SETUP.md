## General Setup

1. Set up the base model:

   ```crystal
   # ->>> src/models/base_model.cr

   abstract class BaseModel < Avram::Model
     # ...
     include Shield::Model
     # ...
   end
   ```
   
1. Set up base actions:

   ```crystal
   # ->>> src/actions/browser_action.cr

   abstract class BrowserAction < Lucky::Action
     # ...
     include Shield::Action

     # What to do if user is **not** logged in
     # but the action requires user to be logged in.
     #
     #def require_logged_in_action
     #  flash.failure = "You are not logged in"
     #  redirect to: Logins::New
     #end

     # What to do if user is logged in but the action
     # requires user to **not** be logged in.
     #
     #def require_logged_out_action
     #  flash.info = "You are already logged in"
     #  redirect_back fallback: CurrentUser::Show
     #end

     # What to do if user is not allowed to perform action
     #
     #def not_authorized_action(user, action, record)
     #  flash.failure = "You are not allowed to perform this action!"
     #  redirect to: CurrentUser::Show
     #end
     # ...
   end
   ```

   ---
   ```crystal
   # ->>> src/actions/api_action.cr

   abstract class ApiAction < Lucky::Action
     # ...
     include Shield::Action

     # What to do if user is **not** logged in
     # but the action requires user to be logged in.
     #
     #def require_logged_in_action
     #  flash.failure = "You are not logged in"
     #  redirect to: Logins::New
     #end

     # What to do if user is logged in but the action
     # requires user to **not** be logged in.
     #
     #def require_logged_out_action
     #  flash.info = "You are already logged in"
     #  redirect_back fallback: CurrentUser::Show
     #end

     # What to do if a user is not allowed to perform action
     #
     #def not_authorized_action(user, action, record)
     #  flash.failure = "You are not allowed to perform this action!"
     #  redirect to: CurrentUser::Show
     #end
     # ...
   end
   ```
