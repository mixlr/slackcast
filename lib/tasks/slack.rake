namespace :slack do
  task :start_client => :environment do
    SlackClient.new.start!
  end
end
