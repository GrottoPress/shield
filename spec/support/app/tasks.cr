ENV["LUCKY_TASK"] = "true"

require "./src/app"
# require "./tasks/**"
require "./db/migrations/**"
require "lucky/tasks/**"

LuckyCli::Runner.run
