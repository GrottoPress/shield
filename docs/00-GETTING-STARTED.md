## Getting Started

*Shield*'s core philosophy is to **deny by default**. It locks everything down, without regard to the security policy, or usability requirements, of the parent application.

It is up to applications to explicitly disable features it finds an overkill for its specific use case. In *Shield*, most features can be disabled by `skip`ping the relevant action pipes.

This posture makes it difficult for an application to be *insecure by accident*.

### Requirements

- *Crystal* **0.35.1**: Learn to install *Crystal* [here &raquo;](https://crystal-lang.org/install/)
- *Lucky* **0.25.0**: Learn to install *Lucky* [here &raquo;](https://luckyframework.org/guides/getting-started/installing)

### Generating a new *Lucky* project

Use [*Penny*](https://github.com/GrottoPress/penny). *Penny* is a *Lucky* application scaffold that gets you up and running with *Shield*.

If you would rather start from scratch, generate a new *Lucky* project without authentication, with the `--no-auth` flag: `lucky init.custom my_app --no-auth`.

### Caveats

*Shield* patches *Lucky* and [*Avram*](https://github.com/luckyframework/avram) in a few places. This may lead to behaviours that are inconsistent with core *Lucky* and *Avram*. Take note of the following:

1. *Shield* disables the default validation performed by *Avram* in save operations. See [#1209 (comment)](https://github.com/luckyframework/lucky/discussions/1209#discussioncomment-46030). You have to **explicitly** define validations for all attributes in save operations.

1. In *Avram*, `after_save` hook does not run for updates if no columns changed. In *Shield*, it always runs, and inside the transation so that roll backs are possible. See https://github.com/luckyframework/avram/issues/604
