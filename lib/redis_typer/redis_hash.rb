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

    def read(key)
      if redis.exists(key)
        new(key, redis.hgetall(key))
      end
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

  def update(hash)
    assert_valid_keys(hash)
    delete_obsolete_attributes(hash)
    assign_attributes(hash)
    save
  end

  def patch(hash)
    assert_valid_keys(hash)
    assign_attributes(hash)
    save
  end

  def delete
    redis.del(@key)
    self
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

  def assign_attributes(hash)
    hash.each_pair { |k, v| send("#{k}=", v) }
  end

  def delete_obsolete_attributes(hash)
    obsolete_keys = marshal_dump.keys - hash.keys
    redis.hdel(@key, *obsolete_keys)
    obsolete_keys.map &method(:delete_field)
  end

  def serialize
    Array(marshal_dump)
  end
end

end
