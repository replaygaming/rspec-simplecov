# Rspec::Simplecov

Creates an after suite hook in RSpect that dynamically creates and injects a new
test case that expects the actual code coverage to be at least the lower limit
set in Simplecov.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rspec-simplecov'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rspec-simplecov

## Usage

If you are already using Rspec and SimpleCov you probably have this somewhere
near the top of your `spec_helper.rb`:

```ruby
require 'simplecov'

SimpleCov.minimum_coverage 95
SimpleCov.start

RSpec.configure do |config|
  # ...
```

All you need to do is require and add the initializer line for RSpec::SimpleCov
like this:

```ruby
require 'simplecov'
require 'rspec/simplecov'

SimpleCov.minimum_coverage 95
SimpleCov.start

RSpec::SimpleCov.start

RSpec.configure do |config|
  # ...
``

And you to can enjoy the glory of a failing RSpec suite when your code coverage
drops below `SimpleCov.minimum_coverage` :)

## Contributing

1. Fork it ( https://github.com/[my-github-username]/rspec-simplecov/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
