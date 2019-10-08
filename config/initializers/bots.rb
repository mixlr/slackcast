# Add bot and commands
Rails.application.config.autoload_paths += [
  'app/bot',
  'app/services',
  'app/services/commands'
]
