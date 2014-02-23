# RedisTyper

Experimental implementation of a Redis wrapper in Ruby

## Installation

Add this line to your application's Gemfile:

    gem 'redis_typer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install redis_typer

## Usage

```ruby
my_hash = RedisTyper::RedisHash.create('my_hash', spam: 'eggs')
my_hash.spam   # => 'eggs'
my_hash.update(xxx: 'zzz')
my_hash.save
my_hash.xxx    # => 'zzz'
my_hash.length # => 2
my_hash.values # => #<Set: {"eggs", "zzz"}>
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
