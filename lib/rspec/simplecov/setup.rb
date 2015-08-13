require 'rspec'
require 'simplecov'

module RSpec
  module SimpleCov
    module Setup

      class << self

        # Ugly hack ...
        def with_metadata_key_location_unreserved
          RSpec::Core::Metadata::RESERVED_KEYS.delete(:location)
          yield
          RSpec::Core::Metadata::RESERVED_KEYS.push(:location)
        end

        def do( configuration )
          RSpec.configure do |config|

            config.after(:suite) do
              # Setup empty vars to hold the group and example refs.
              coverage_example_group = nil
              coverage_example_context = nil
              coverage_example = nil

              # Build the fake test for coverage
              RSpec::SimpleCov::Setup.with_metadata_key_location_unreserved do
                coverage_example_group = RSpec.describe( configuration.described_thing, location: 'spec_helper_spec.rb') do
                  coverage_example_context = context configuration.context_text do
                    coverage_example = it configuration.test_case_text do
                      expect( configuration.described_thing.result.covered_percent ).to be >= configuration.described_thing.minimum_coverage
                    end
                  end
                end
              end

              # Run the test
              RSpec.configuration.reporter.example_group_started coverage_example_group
              RSpec.configuration.reporter.example_group_started coverage_example_context
              RSpec.configuration.reporter.example_started coverage_example
              coverage_example_group.run

              coverage_example_group.metadata[ :absolute_file_path ] = configuration.caller_path
              coverage_example_group.metadata[ :rerun_file_path ] = configuration.caller_path
              coverage_example_group.metadata[ :file_path ] = configuration.caller_path

              if coverage_example.execution_result.exception
                coverage_example.execution_result.exception.backtrace.push( *configuration.backtrace )
              end

              # Evaluate the result
              passed = coverage_example.execution_result.status == :passed
              failed = !passed

              # Message the reporter to have it show up in the results 
              RSpec.configuration.reporter.example_failed coverage_example if failed
              RSpec.configuration.reporter.example_passed coverage_example if passed

              # Close out the reporter groups
              RSpec.configuration.reporter.example_group_finished coverage_example_context
              RSpec.configuration.reporter.example_group_finished coverage_example_group
            end
          end
        end

      end

    end
  end
end
