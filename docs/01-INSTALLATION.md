## Installation

*Shield* requires [*Lucky*](https://luckyframework.org) version **0.23.0** or newer.

1. Add the dependency to your `shard.yml`:

   ```yaml
   # ->>> shard.yml

   # ...
   dependencies:
     shield:
       github: GrottoPress/shield
       branch: master
   # ...
   ```

1. Run `shards install`

1. In `src/app.cr` of your application (or whatever your app's bootstrap file is), `require "shield"`:

```crystal
# ->>> src/app.cr

# ...
require "shield"
# ...
```
