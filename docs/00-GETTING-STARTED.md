## Getting Started

*Shield*'s core philosophy is to **deny by default**. It locks everything down, without regard to the security policies, or user experience, of the consumer application.

It is up to the consumer application to explicitly disable features it finds an overkill for its specific use case. In *Shield*, most features can be disabled by `skip`ping the relevant action pipes.

This posture makes it difficult for an application to be *insecure by accident*.

### Requirements

- *Crystal* **0.35.1**: Learn to install *Crystal* [here &raquo;](https://crystal-lang.org/install/)
- *Lucky* **0.23.0**: Learn to install *Lucky* [here &raquo;](https://luckyframework.org/guides/getting-started/installing)

### Generating a new *Lucky* project

*Lucky* ships with [*Authentic*](https://github.com/luckyframework/authentic), by default, and it's generator assumes you would be using it.

To use *Shield* instead, generate a new *Lucky* project without authentication, with the `--no-auth` flag: `lucky init.custom my_app --no-auth`.

### Caveats

*Shield* patches *Lucky* and [*Avram*](https://github.com/luckyframework/avram) in a few places. Worthy of note is that *Shield* disables the default validation performed by *Avram* in save operations. See [#1209 (comment)](https://github.com/luckyframework/lucky/discussions/1209#discussioncomment-46030)

You have to **explicitly** define validations for all attributes in save operations.
