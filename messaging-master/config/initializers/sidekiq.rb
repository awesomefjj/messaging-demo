redis_conn = proc {
  Redis::Namespace.new(
    ENV.fetch('REDIS_NAMESPACE'),
    redis: Redis.new(url: ENV.fetch('REDIS_URL'), connect_timeout: 1, read_timeout: 0.5, write_timeout: 0.5)
  )
}

size = ENV.fetch('REDIS_POOLS', 5).to_i
size = [size, Sidekiq.options[:concurrency] + 2].max
pool = ConnectionPool.new(size: size, &redis_conn)
Redis.current = redis_conn.call

Sidekiq.configure_client do |config|
  config.redis = pool
end

Sidekiq.configure_server do |config|
  config.redis = pool
end
