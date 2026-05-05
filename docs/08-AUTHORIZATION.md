## Authorization

*Shield* enforces authorization in actions via the `before :check_authorization` pipe. Authorization is denied, by default, for all actions.

Each action may define an authorization rule by using the `.authorize_user(&)` macro. If the block passed to the macro returns `true`, authorization is granted, otherwise it is denied:

```crystal
# ->>> src/actions/browser_action.cr

abstract class BrowserAction < Lucky::Action
  # ...
  authorize_user do |user|
    user.level.admin?
  end
  # ...
end
```

```crystal
# ->>> src/actions/posts/update.cr

class Posts::Update < BrowserAction
  # ...
  authorize_user do |user|
    super || post.user_id == user.id
  end
  # ...
end
```

While the `.authorize_user(&)` macro is used to authorize a logged in user, there's a separate `.authorize(&)` macro for authorizing a logged out user:

```crystal
# ->>> src/actions/posts/show.cr

class Posts::Show < BrowserAction
  skip :require_logged_in
  skip :require_logged_out
  # ...

  # This is used if the user is logged in
  authorize_user do |user|
    super || post.user_id == user.id || post.published?
  end

  # This is used if the user is logged out
  authorize do
    post.published?
  end
  # ...
end
```

If authorization is denied, `#do_check_authorization_failed` (which you set up in the base actions) is called.

1. Set up actions:

   ```crystal
   # ->>> src/actions/browser_action.cr

   abstract class BrowserAction < Lucky::Action
     # ...
     # What to do if user is not allowed to perform action
     #
     #def do_check_authorization_failed
     #  flash.failure = Rex.t(:"action.pipe.authorization_failed")
     #  redirect_back fallback: CurrentUser::Show
     #end
     # ...
   end
   ```

### Integration with third-party authorization shards

If you need to, you may use *Shield* with an authorization shard, such as [*LuckyCan*](https://github.com/confact/lucky_can) or [*Praetorian*](https://github.com/ilanusse/praetorian).

In this case, define your authorization policies as usual:

```crystal
# ->>> src/policies/post_policy.cr

# This example uses *LuckyCan*
class PostPolicy < LuckyCan::BasePolicy
  # ...
  can update, post, current_user do
    current_user.level.admin? || post.user_id == current_user.id
  end
  # ...
end
```

In the relevant action, call the relevant authorization shard helper:

```crystal
# ->>> src/actions/posts/update.cr

# This example uses *LuckyCan*
class Posts::Update < BrowserAction
  # ...
  authorize_user do |user|
    # Call the shard's helper here. MUST return `Bool`
    PostPolicy.update?(post, user)
  end
  # ...
end
```

That's it! *Shield* takes care of the rest.
