namespace :slack do
  task :start_client => :environment do
    client = SlackClient.new

    begin
      auth = client.auth_test

      if auth.ok?
        Rails.logger.info "Connected to %s as %s" % [auth.team, auth.user]
        client.id = auth.user_id
        client.start!
      else
        Rails.logger.error "Unable to authenticate"
        exit 1
      end
    rescue Slack::Web::Api::Errors::SlackError => e
      Rails.logger.error "Authentication error: %s" % e.message
      exit 1
    end
  end
end
