Airbrake.configure do |c|
  c.project_id = ENV['AIRBRAKE_PROJECT_ID']
  c.project_key = ENV['AIRBRAKE_PROJECT_KEY']
end if Rails.env.production?
