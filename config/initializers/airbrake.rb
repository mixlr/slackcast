ignore_environments = %w(development test)

unless ignore_environments.include?(Rails.env)
  Airbrake.configure do |c|
    c.ignore_environments = ignore_environments
    c.project_id          = ENV['AIRBRAKE_PROJECT_ID']
    c.project_key         = ENV['AIRBRAKE_PROJECT_KEY']
    c.environment         = ENV['RAILS_ENV']
    c.root_directory      = ENV['RAILS_ROOT']
    c.performance_stats   = ENV['AIRBRAKE_PERFORMANCE_STATS_ENABLED']
    c.app_version         = ENV['HEROKU_RELEASE_VERSION']
    c.versions            = {
      rails: Rails.version,
      ruby: RUBY_VERSION,
      bundler: ENV['BUNDLER_VERSION']
    }
  end
end
