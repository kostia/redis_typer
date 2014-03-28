require 'pry'
require 'redis_typer'

module Helpers
  def redis
    Redis.new
  end
end

RSpec.configure do |config|
  config.include Helpers

  config.before do
    keys = redis.keys('*')
    redis.del(*keys) if keys.any?
  end
end
