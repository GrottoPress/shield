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

     # If you are worried about users on mobile, you may want
     # to disable pinning a login to its IP address
     #skip :pin_login_to_ip_address

     # What to do if user is **not** logged in
     # but the action requires user to be logged in.
     #
     #def do_require_logged_in_failed
     #  flash.failure = "You are not logged in"
     #  redirect to: Logins::New
     #end

     # What to do if user is logged in but the action
     # requires user to **not** be logged in.
     #
     #def do_require_logged_out_failed
     #  flash.info = "You are already logged in"
     #  redirect_back fallback: CurrentUser::Show
     #end

     # What to do if user is not allowed to perform action
     #
     #def do_check_authorization_failed
     #  flash.failure = "You are not allowed to perform this action!"
     #  redirect_back fallback: CurrentUser::Show
     #end

     # What to do when a logged in user's IP address changes, if the
     # action requires the user's IP to match the IP they used to
     # log in.
     #
     #def do_pin_login_to_ip_address_failed
     #  flash.failure = "Your IP address has changed. Please log in again."
     #  redirect to: Logins::New
     #end

     # What to do when a user's IP address changes in a password reset, if the
     # action requires the user's IP to match the IP with which they requested
     # the password reset.
     #
     #def do_pin_password_reset_to_ip_address_failed
     #  flash.failure = "Your IP address has changed. Please try again."
     #  redirect to: PasswordResets::New
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

     # If you are worried about users on mobile, you may want
     # to disable pinning a login to its IP address
     #skip :pin_login_to_ip_address

     # What to do if user is **not** logged in
     # but the action requires user to be logged in.
     #
     #def do_require_logged_in_failed
     #  flash.failure = "You are not logged in"
     #  redirect to: Logins::New
     #end

     # What to do if user is logged in but the action
     # requires user to **not** be logged in.
     #
     #def do_require_logged_out_failed
     #  flash.info = "You are already logged in"
     #  redirect_back fallback: CurrentUser::Show
     #end

     # What to do if user is not allowed to perform action
     #
     #def do_check_authorization_failed
     #  flash.failure = "You are not allowed to perform this action!"
     #  redirect_back fallback: CurrentUser::Show
     #end

     # What to do when a logged in user's IP address changes, if the
     # action requires the user's IP to match the IP they used to
     # log in.
     #
     #def do_pin_login_to_ip_address_failed
     #  flash.failure = "Your IP address has changed. Please log in again."
     #  redirect to: Logins::New
     #end

     # What to do when a user's IP address changes in a password reset, if the
     # action requires the user's IP to match the IP with which they requested
     # the password reset.
     #
     #def do_pin_password_reset_to_ip_address_failed
     #  flash.failure = "Your IP address has changed. Please try again."
     #  redirect to: PasswordResets::New
     #end
     # ...
   end
   ```
