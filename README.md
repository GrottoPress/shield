# Shield

*Shield* is a comprehensive security solution for [*Lucky* framework](https://luckyframework.org). It features robust authentication and authorization, including user registrations, logins and logouts, password resets and more.

*Shield* is secure by default, and exploits defence-in-depth strategies, including the option to pin an authentication session to the IP address that started it -- the session is invalidated if the IP address changes.

User IDs are never saved in session. Instead, each authentication gets a unique ID and token, which is saved in session, and checked against their corresponding salted SHA-256 hashes in the database.

When a user changes their password, *Shield* logs out the user on all devices (except the current one), to ensure that an attacker no longer has access to a previously compromised account.

Shield supports API authentication, with regular passwords or with user-generated bearer tokens. In addition, all authentication actions that can be performed in the browser have their API equivalents.

*Shield* is designed to be resilient against critical application vulnerabilities, including brute force, user enumeration, denial of service and timing attacks.

On top of these, *Shield* offers seamless integration with your application. For the most part, `include` a bunch of `module`s in the appropriate `class`es, and you are good to go!

## Documentation

Find the complete documentation of *Shield* in the `docs/` directory of this repository.

## Todo

- [x] User registrations
- [x] Logins and logouts
- [x] Password resets
- [x] Login notifications
- [x] Password change notifications
- [x] Pin authentication session to its IP address
- [x] Authorization
- [x] Email confirmation
- [x] *Bearer* logins (API tokens)
- [x] Login idle timeout
- [x] Pwned Passwords integration
- [ ] Multi-factor authentication

## Development

Run tests with `docker-compose run --rm spec`. If you need to update shards before that, run `docker-compose run --rm shards`.

If you would rather run tests on your local machine (ie, without docker), create a `.env.sh` file:

```bash
#!/bin/bash

export APP_DOMAIN=http://localhost:5000
export DATABASE_URL='postgres://postgres:password@localhost:5432/shield_spec'
export SECRET_KEY_BASE='XeqAgSy5QQ+dWe8ruOBUMrz9XPbPZ7chPVtz2ecDGss='
export SERVER_HOST='0.0.0.0'
export SERVER_PORT=5000
```

Update the file with your own details. Then run tests with `source .env.sh && crystal spec`.

## Contributing

1. [Fork it](https://github.com/GrottoPress/shield/fork)
1. Switch to the `dev` branch: `git checkout dev`
1. Create your feature branch: `git checkout -b my-new-feature`
1. Make your changes, updating changelog and documentation as appropriate.
1. Commit your changes: `git commit`
1. Push to the branch: `git push origin my-new-feature`
1. Submit a new *Pull Request* against the `GrottoPress:dev` branch.

## Security

Kindly report suspected security vulnerabilities in private, via contact details outlined in this repository's `.security.txt` file.
