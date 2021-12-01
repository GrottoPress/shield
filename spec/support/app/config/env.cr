unless Bool.adapter.parse(ENV["SKIP_LOAD_ENV"]?.to_s).value
  LuckyEnv.load(".env")
end
