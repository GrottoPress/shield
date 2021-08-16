module Shield::UserSettingsColumn
  macro included
    column settings : UserSettings, serialize: true
  end
end
