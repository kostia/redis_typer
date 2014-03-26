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

  describe '#update' do
    def update
      subject.update(hash_key1: 'hash value 1*', hash_key3: 'hash value 3')
    end

    before { RedisHash.create('xxx', hash_key1: 'hash value 1', hash_key2: 'hash value 2') }

    subject { RedisHash.read('xxx') }

    it 'creates new hash entries' do
      expect { update }.to change { redis.hget('xxx', :hash_key3) }.from(nil).to('hash value 3')
    end

    it 'adds new instance fields' do
      expect { update }.to change { subject.hash_key3 }.from(nil).to('hash value 3')
    end

    it 'updates corresponding hash entries' do
      expect { update }.to change { redis.hget('xxx', :hash_key1) }
          .from('hash value 1').to('hash value 1*')
    end

    it 'updates corresponding instance fields' do
      expect { update }.to change { subject.hash_key1 }.from('hash value 1').to('hash value 1*')
    end

    it 'deletes obsolete hash entries' do
      expect { update }.to change { redis.hget('xxx', :hash_key2) }.from('hash value 2').to(nil)
    end

    it 'deletes obsolete instance fields' do
      expect { update }.to change { subject.hash_key2 }.from('hash value 2').to(nil)
    end
  end

  describe '#patch' do
    def patch
      subject.patch(hash_key1: 'hash value 1*', hash_key3: 'hash value 3')
    end

    before { RedisHash.create('xxx', hash_key1: 'hash value 1', hash_key2: 'hash value 2') }

    subject { RedisHash.read('xxx') }

    it 'creates new hash entries' do
      expect { patch }.to change { redis.hget('xxx', :hash_key3) }.from(nil).to('hash value 3')
    end

    it 'adds new instance fields' do
      expect { patch }.to change { subject.hash_key3 }.from(nil).to('hash value 3')
    end

    it 'updates corresponding hash entries' do
      expect { patch }.to change { redis.hget('xxx', :hash_key1) }
          .from('hash value 1').to('hash value 1*')
    end

    it 'updates corresponding instance fields' do
      expect { patch }.to change { subject.hash_key3 }.from(nil).to('hash value 3')
    end

    it 'keeps not mentioned hash entries and instance fields' do
      expect { patch }.to_not change { subject.hash_key2 }
      expect { patch }.to_not change { redis.hget('xxx', :hash_key2) }
    end
  end
end

end
