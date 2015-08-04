require "rspec/simplecov/configuration"
require "rspec/simplecov/setup"
require "rspec/simplecov/version"

module RSpec
  module SimpleCov
    class << self

      def start( simplecov_instance = ::SimpleCov, &block )
        configuration = Configuration.new( simplecov_instance, caller.to_a, &block )

        Setup.do( configuration )
      end

    end
  end
end
