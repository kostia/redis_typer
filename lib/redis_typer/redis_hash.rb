require 'ostruct'

module RedisTyper

class RedisHash < OpenStruct
  FORBIDDEN_KEYS = %w[key].freeze

  ForbiddenKeyError = Class.new(ArgumentError)

  attr_reader :key

  class << self
    def create(key, hash)
      new(key, hash).tap { |redis_hash| redis_hash.save }
    end

    def redis
      Redis.new
    end
  end

  def initialize(key, hash)
    @key = key
    assert_valid_keys(hash)
    super(hash)
  end

  def save
    redis.hmset(@key, *serialize)
  end

  private

  def redis
    self.class.redis
  end

  def assert_valid_keys(hash)
    hash.each_key do |key|
      if FORBIDDEN_KEYS.include?(key.to_s)
        raise ForbiddenKeyError.new(%{Key "#{key}" is now allowed as hash key})
      end
    end
  end

  def serialize
    Array(marshal_dump)
  end
end

end
