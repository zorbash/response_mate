$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'response_mate'
require 'fakeweb'
require 'coveralls'

Coveralls.wear!

Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

module OutputHelpers
  # Deprecated in active_support due to thread-safety
  # see: https://github.com/rails/rails/blob/v4.2.2/activesupport/lib/active_support/core_ext/kernel/reporting.rb#L114
  # We use it only as a testing helper in a non-threaded environment
  def quietly
    silence_stream(STDOUT) do
      silence_stream(STDERR) do
        yield
      end
    end
  end
end

RSpec.configure do |c|
  c.include OutputHelpers
end
