module Shield
  VERSION = {{ `shards version "#{__DIR__}"`.chomp.stringify }}
end
