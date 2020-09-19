## Other Types

The following types are available for use, if needed:

### Operations

1. `Shield::DeleteUser`

   `Shield::DeleteUser` deletes a user, given a user ID. It protects against self-deletion; a user cannot delete themselves.

   It is currently used in `Shield::Users::Destroy`, where an admin deletes a registered user.

   Set up as follows:

   ```crystal
   # ->>> src/operations/delete_user.cr

   class DeleteUser < Avram::BasicOperation
     # ...
     include Shield::DeleteUser
     # ...
   end
   ```

### Actions

- `Shield::Users::Create` (for `Users::Create`)
- `Shield::Users::Destroy` (for `Users::Destroy`)
- `Shield::Users::Edit` (for `Users::Edit`)
- `Shield::Users::Index` (for `Users::Index`)
- `Shield::Users::New` (for `Users::New`)
- `Shield::Users::Show` (for `Users::Show`)
- `Shield::Users::Update` (for `Users::Update`)
