## Getting Started

*Shield*'s core philosophy is to **deny by default**. It locks everything down, without regard to the security policy, or usability requirements, of the parent application.

It is up to applications to explicitly disable features it finds an overkill for its specific use case. In *Shield*, most features can be disabled by `skip`ping the relevant action pipes.

This posture makes it difficult for an application to be *insecure by accident*.

### Requirements

- *Crystal* `~> 1.6`: Learn to install *Crystal* [here &raquo;](https://crystal-lang.org/install/)
- *Lucky* `~> 1.0`: Learn to install *Lucky* [here &raquo;](https://luckyframework.org/guides/getting-started/installing)
- *Carbon* `~> 0.3.0`: Learn to install *Carbon* [here &raquo;](https://github.com/luckyframework/carbon)

### Generating a new *Lucky* project

Use [*Penny*](https://github.com/GrottoPress/penny). *Penny* is a *Lucky* application scaffold that gets you up and running with *Shield*.

If you would rather start from scratch, generate a new *Lucky* project without authentication, with the `--no-auth` flag: `lucky init.custom my_app --no-auth`.

### Caveats

Take note of the following:

1. *Shield* throws away the `allow_external` parameter in `Lucky::Action#redirect_back`, so the only way to return to an external URL is to set the external URL, before calling `#redirect_back`, thus: `ReturnUrlSession.new(session).set("http://external.url")`.
