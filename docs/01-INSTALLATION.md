## Installation

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

1. In your app's bootstrap, require *Shield*:

```crystal
# ->>> src/app.cr

# ...
require "shield"
# ...
```

1. Require *presets*, right after models:

```crystal
# ->>> src/app.cr

# ...
require "shield"
# ...
require "./models/base_model"
require "./models/**"

require "shield/presets"
# ...
```
