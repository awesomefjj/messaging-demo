require 'raven/base'
if ENV['SENTRY_DSN'].present?
  require 'sentry-raven'
  require 'raven/integrations/rails'
  require 'raven/integrations/sidekiq'
  Raven.configure do |config|
    config.async = lambda { |event|
      SentryJob.perform_later(event)
    }
    config.dsn = ENV['SENTRY_DSN']
    config.breadcrumbs_logger = [:active_support_logger]
    config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
    release_commit_file = Rails.root.join('RELEASE_COMMIT')
    release_commit = IO.read(release_commit_file).strip if File.exist?(release_commit_file)
    config.release = release_commit if release_commit.present?
    config.environments = %w[dev staging production]
  end
end
