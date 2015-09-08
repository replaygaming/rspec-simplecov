module RSpec
  module SimpleCov
    class Container
      attr_accessor :example_group, :example_context, :example

      def initialize
        @example_group = nil
        @example_context = nil
        @example = nil
      end
    end

    module Setup

      class << self

        def with_metadata_key_location_unreserved
          RSpec::Core::Metadata::RESERVED_KEYS.delete(:location)
          yield
          RSpec::Core::Metadata::RESERVED_KEYS.push(:location)
        end

        def build_contexts_and_example( coverage, configuration )
          RSpec::SimpleCov::Setup.with_metadata_key_location_unreserved do
            coverage.example_group = RSpec.describe( configuration.described_thing, location: 'spec_helper_spec.rb') do
              coverage.example_context = context configuration.context_text do
                coverage.example = it configuration.test_case_text do
                  result = configuration.described_thing.result
                  minimum_coverage = configuration.described_thing.minimum_coverage
                  configuration.described_thing.running = true
                  
                  expect( result.covered_percent ).to be >= minimum_coverage
                end
              end
            end
          end
        end

        def run_example( coverage )
          RSpec.configuration.reporter.example_group_started coverage.example_group
          RSpec.configuration.reporter.example_group_started coverage.example_context
          RSpec.configuration.reporter.example_started coverage.example
          coverage.example_group.run
        end

        def reset_example_group_paths( example_group, path )
          example_group.metadata[ :absolute_file_path ] = path
          example_group.metadata[ :rerun_file_path ] = path
          example_group.metadata[ :file_path ] = path
        end

        def fix_example_backtrace( example, backtrace )
          return unless example.execution_result.exception
          
          example.execution_result.exception.backtrace.push( *backtrace )
        end

        def evaluate_and_report_result( example )
          passed = example.execution_result.status == :passed
          failed = !passed

          RSpec.configuration.reporter.example_failed example if failed
          RSpec.configuration.reporter.example_passed example if passed
        end

        def mark_contexts_as_finished( coverage )
          RSpec.configuration.reporter.example_group_finished coverage.example_context
          RSpec.configuration.reporter.example_group_finished coverage.example_group
        end

        def do( configuration )
          RSpec.configure do |config|

            config.after(:suite) do
              coverage = Container.new

              include RSpec::SimpleCov

              Setup.build_contexts_and_example( coverage, configuration )

              Setup.run_example( coverage )

              Setup.reset_example_group_paths( coverage.example_group, configuration.caller_path )

              Setup.fix_example_backtrace( coverage.example, configuration.backtrace )

              Setup.evaluate_and_report_result( coverage.example )

              Setup.mark_contexts_as_finished( coverage )
            end
          end
        end

      end

    end
  end
end
