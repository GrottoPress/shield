## Authorization

*Shield* enforces authorization in actions via the `before :check_authorization` pipe. Authorization is denied, by default, for all actions.

Each action may define an authorization rule by calling the `.authorize(&)` macro. If the block evaluates to `true`, authorization is granted, otherwise it is denied:

```crystal
# ->>> src/actions/browser_action.cr

abstract class BrowserAction < Lucky::Action
  # ...
  authorize do |user|
    user.level.admin?
  end
  # ...
end
```

```crystal
# ->>> src/actions/posts/update.cr

class Posts::Update < BrowserAction
  # ...
  authorize do |user|
    # `super` calls `.authorize` from the parent class
    super || post.user_id == user.id
  end
  # ...
end
```

If authorization is denied, `#do_check_authorization_failed` (which you set up in the base actions) is called.

Authorization is always skipped if the current user is not logged in. If you wish to deny access for such a user, there's the `before :require_logged_in` pipe.

The `:check_authorization` pipe is for authorizing a **logged in** user to perform an *action* on the action's resource, based on the user's role and capabilities, relative to the resource.

It should not be used for any other type of authorization. For instance, if you need to restrict access based on IP address, you should define a new pipe for that.

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
  authorize do |user|
    # Call the shard's helper here. MUST return `Bool?`
    PostPolicy.update?(post, user)
  end

  # ...
end
```

That's it! *Shield* takes care of the rest.
