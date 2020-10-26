## General Setup

1. Configure:

   *Shield* uses *Habitat*, which comes bundled with *Lucky*, for configuration.

   ---
   ```crystal
   # ->>> config/shield.cr

   Shield.configure do |settings|
     # The cost to apply to bcrypt hashes
     settings.bcrypt_cost = Lucky::Env.production? ? 12 : 4

     # Required minimum length of password
     #settings.password_min_length = 12

     # Require lowercase letter in password?
     #settings.password_require_lowercase = true

     # Require uppercase letter in password?
     #settings.password_require_uppercase = true

     # Require number in password?
     #settings.password_require_number = true

     # Require special character in password?
     #settings.password_require_special_char = true
   end
   ```

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

1. Set up helpers:

   At the core of *Lucky*'s philosophy is keeping business logic out of database models, and into operations. This works great for operation-specific business logic.

   There may be cases where specific functionality do not fit into an operation, or fit into more than one operation. The convention is to use mixins (modules), and `include` them wherever they are needed.

   *Shield* uses helpers instead. *Helpers* are modules with methods that are called directly, as namespaced module methods, rather than included in another type.

   *Shield*'s approach ensures such methods really stay in one place, rather than duplicated in multiple types. It also avoids including methods in a type that may never be used, or having one method per mixin (module) as an attempt to avoid the former.

   ---
   ```crystal
   # ->>> src/helpers/crypto_helper.cr

   module CryptoHelper
     # ...
     extend Shield::CryptoHelper
     # ...
   end
   ```

   `Shield::CryptoHelper` contains methods for generating, hashing and verifying passwords, and tokens.

1. Set up utilities:

   *Utilities* are (plain old *Crystal*) objects with domain-specific business logic. You may know them as non-database models. *Shield* calls them *Utilities* to differentiate them from database-backed models.

   ---
   ```crystal
   # ->>> src/utilities/page_url_session.cr

   class PageUrlSession # Or `struct ...`
     # ...
     include Shield::PageUrlSession
     # ...
   end
   ```

   `Shield::PageUrlSession` is a wrapper around *Lucky* sessions that deals with session keys and values for the page previous to the current page.

   ---
   ```crystal
   # ->>> src/utilities/return_url_session.cr

   class ReturnUrlSession # Or `struct ...`
     # ...
     include Shield::ReturnUrlSession
     # ...
   end
   ```

   `Shield::ReturnUrlSession` is a wrapper around *Lucky* sessions that deals with session keys and values for the URL to return to.

   `#redirect_back` checks for this session value first, and redirects to it if present.

   *Shield* throws away the `allow_external` parameter in `Lucky::Action#redirect_back`, so the only way to return to an external URL is to set the external URL thus: `ReturnUrlSession.new(session).set("http://external.url")`.
