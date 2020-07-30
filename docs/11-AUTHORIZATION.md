## Authorization

`Shield::Model` adds in `Shield::Authorization`, which allows a model to define what actions a registered user is authorized to take on that model.

1. Set up models:

   ```crystal
   # ->>> src/models/post.cr

   class Post < BaseModel
     # ...
     # Allow only "admin" users to delete any given post
     authorize :delete do |user, post|
       user.level.admin?
     end

     # Allow only "admin" users and the post author, to update
     # a given post.
     authorize :update do |user, post|
       user.level.admin? || user.id == post.try(&.author!.id)
     end

     # Allow anyone to create or read any post
     authorize :create, :read do |user, post|
       true
     end
     # ...
   end
   ```

   `.authorize` accepts a list of authorized actions, and yields the user requesting authorization and the record (or nil).

   The block passed to `.authorize` must return a `Bool` -- `true` to authorize the actions, or `false` to deny them. The default is to deny (`false`).

   There are 4 possible authorized actions:

   - `Shield::AuthorizedAction::Read`
   - `Shield::AuthorizedAction::Create`
   - `Shield::AuthorizedAction::Update`
   - `Shield::AuthorizedAction::Delete`

   Check whether a given user is allowed to perform a given action:

   ```crystal
   user = UserQuery.find(1)
   post = PostQuery.find(2)

   # Equivalent to `post.allow?(user, :read)`
   user.can?(:read, post) # <= `true`

   # Here, we are checking authorization for `Post` class, instead
   # of a specific post instance.
   #
   # Equivalent to `Post.allow?(user, :read)`
   user.can?(:create, Post) # <= `true`
   ```

1. Set up *Lucky* actions:

   By default, all *Lucky* actions are required to check authorization for the current user, by calling `#authorize`.

   ```crystal
   # ->>> src/actions/posts/show.cr

   class Posts::Show < BrowserAction
     # ...
     get "/posts/:post_id" do
       authorize(:read, post) do
         html ShowPage, post: post
       end
     end

     private def post
       PostQuery.find(post_id)
     end
     # ...
   end
   ```

   ```crystal
   # ->>> src/actions/posts/new.cr

   class Posts::New < BrowserAction
     # ...
     get "/posts/new" do
       authorize(:create, Post) do
         html NewPage
       end
     end
     # ...
   end
   ```

   A *Lucky* action raises a `Shield::NoAuthorizationError` if `#authorize` is not called. You may skip this requirement by calling `skip :require_authorization`.
   
   Authorization is always skipped if the current user is not logged in. If you wish to deny access for such a user, use the `before :require_logged_in` pipe.

   `#authorize` defers to the passed model/record to check if the current user is allowed to perform the requested action. If authorization fails, `#not_authorized_action` (which you set up in the base *Lucky* actions) is called.
