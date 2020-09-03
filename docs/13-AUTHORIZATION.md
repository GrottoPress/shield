## Authorization

*Shield* enforces authorization in actions via the `before :check_authorization` pipe. Authorization is denied, by default, for all actions.

Each action may define an authorization rule by overriding it's `#authorize?` method. If the method returns `true`, authorization is granted, otherwise it is denied:

```crystal
# ->>> src/actions/browser_action.cr

class BrowserAction < Lucky::Action
  # ...
  def authorize? : Bool
    current_user.try(&.level.admin?) || false
  end
  # ...
end
```

```crystal
# ->>> src/actions/posts/update.cr

class Posts::Update < BrowserAction
  # ...
  def authorize? : Bool
    super || post.user_id == current_user!.id
  end
  # ...
end
```

If authorization is denied, `#do_check_authorization_failed` (which you set up in the base actions) is called.

Authorization is always skipped if the current user is not logged in. If you wish to deny access for such a user, there's the `before :require_logged_in` pipe.

The `:check_authorization` pipe is for authorizing a **logged in** user to perform an *action* on the action's resource, based on the user's role and capabilities, relative to the resource.

It should not be used for any other type of authorization. For instance, if you need to restrict access based on IP address, you should define a new pipe for that.
