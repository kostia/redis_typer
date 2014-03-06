require 'redis_typer'


module RedisTyper

describe RedisHash do
  let(:redis) { Redis.new }

  before do
    keys = redis.keys('*')
    redis.del(*keys) if keys.any?
  end

  describe '.create' do
    it 'does not allow "key" as hash key' do
      expect { RedisHash.create('xxx', key: 'spam') }
        .to raise_error(RedisHash::ForbiddenKeyError, 'Key "key" is now allowed as hash key')
    end

    it 'persists the hash under given key' do
      expect { RedisHash.create('xxx', hash_key1: 'hash value 1', hash_key2: 'hash value 2') }
        .to change { redis.hgetall('xxx') }
        .from({}).to({'hash_key1' => 'hash value 1', 'hash_key2' => 'hash value 2'})
    end

    describe 'returned instance' do
      subject { RedisHash.create('xxx', hash_key1: 'hash value 1', hash_key2: 'hash value 2') }

      its(:key) { should eq('xxx') }
      its(:hash_key1) { should eq('hash value 1') }
      its(:hash_key2) { should eq('hash value 2') }
    end
  end

  describe '.read' do
    context 'with no selection options' do
      subject { RedisHash.read('xxx') }

      context 'if key found' do
        before { redis.hmset('xxx', :hash_key1, 'hash value 1', :hash_key2, 'hash value 2') }

        its(:key) { should eq('xxx') }
        its(:hash_key1) { should eq('hash value 1') }
        its(:hash_key2) { should eq('hash value 2') }
      end

      context 'if key not found' do
        it { should be_nil }
      end
    end
  end
end

end
