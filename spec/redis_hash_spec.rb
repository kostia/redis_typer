require 'redis_typer'


module RedisTyper

describe RedisHash do
  let(:redis) { Redis.new }

  subject { RedisHash.create('xxx', hash_key1: 'hash value 1', hash_key2: 'hash value 2') }

  describe '.create' do
    it 'does not allow "key" as hash key' do
      expect { RedisHash.create('xxx', key: 'spam') }
        .to raise_error(RedisHash::ForbiddenKeyError, 'Key "key" is now allowed as hash key')
    end

    it 'persists the hash under given key' do
      redis.hgetall('xxx').should eq({
        'hash_key1' => 'hash value 1',
        'hash_key2' => 'hash value 2'
      })
    end

    describe 'returned instance' do
      its(:key) { should eq('xxx') }
      its(:hash_key1) { should eq('hash value 1') }
      its(:hash_key2) { should eq('hash value 2') }
    end
  end
end

end
