Slack.configure do |config|
  config.token = ENV.fetch('SLACK_BOT_API_TOKEN') { 'dummy' }

  config.logger = Logger.new(STDOUT).tap { |logger|
    logger.level = ENV.fetch('LOG_LEVEL') { Logger::INFO }
  }
end

Slack::RealTime::Client.configure do |config|
  # Return timestamp only for latest message object of each channel.
  config.start_options[:simple_latest] = true
  # Skip unread counts for each channel.
  config.start_options[:no_unreads] = true
  # Increase request timeout to 5 minutes.
  config.start_options[:request][:timeout] = 300
end
