namespace :slack do
  task :start_client => :environment do
    client = SlackClient.new
    auth   = client.auth_test

    if auth.ok?
      Rails.logger.info "Connected to %s as %s" % [auth.team, auth.user]
      client.id = auth.user_id
      client.start!
    else
      fail 'Unable to connect to Slack'
    end
  end
end
