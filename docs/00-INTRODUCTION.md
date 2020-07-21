## Introduction

*Shield* is a comprehensive security solution for [*Lucky* framework](https://luckyframework.org). It features robust authentication and authorization, including:

- User registrations
- Logins and logouts
- Login notifications (per-user setting)
- Password change notifications (per-user setting)
- Password resets

...and more

*Shield* securely hashes password reset and login tokens, before saving them to the database.

User IDs are never saved in session. Instead, each password reset or login gets a unique ID and token, which is saved in session, and checked against corresponding values in the database.

On top of these, *Shield* offers seamless integration with your application. For the most part, `include` a bunch of `module`s in the appropriate `class`es, and you are good to go!
