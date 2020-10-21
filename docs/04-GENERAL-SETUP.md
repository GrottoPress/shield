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
     include Shield::BrowserAction
     # ...
   end
   ```
