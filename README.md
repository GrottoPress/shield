# Shield

*Shield* is a comprehensive security solution for [*Lucky* framework](https://luckyframework.org), offering robust authentication and authorization for *Lucky* apps.

## Documentation

Find the complete documentation of *Shield* in the `docs/` directory of this repository.

## Development

Run tests with `docker-compose -f spec/docker-compose.yml run --rm spec`. If you need to update shards before that, run `docker-compose -f spec/docker-compose.yml run --rm shards`.

If you would rather run tests on your local machine (ie, without docker), create a `.env.sh` file:

```bash
#!bin/bash

export APP_DOMAIN=http://localhost:5000
export DATABASE_URL='postgres://postgres:password@localhost:5432/shield_spec'
export SECRET_KEY_BASE='XeqAgSy5QQ+dWe8ruOBUMrz9XPbPZ7chPVtz2ecDGss='
export SERVER_HOST='0.0.0.0'
export SERVER_PORT=5000
```

Update the file with your own details. Then run tests with `source .env.sh && crystal spec`.

## Contributing

1. [Fork it](https://github.com/your-github-user/shield/fork)
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Create a new Pull Request

## Security

Kindly report suspected security vulnerabilities in private, via contact details outlined in this repository's `.security.txt` file.
