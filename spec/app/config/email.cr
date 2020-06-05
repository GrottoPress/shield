BaseEmail.configure do |settings|
  settings.adapter = Carbon::DevAdapter.new
end
