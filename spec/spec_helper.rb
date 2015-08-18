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

  # Deprecated in active_support due to thread-safety
  # see: https://github.com/rails/rails/blob/v4.2.2/activesupport/lib/active_support/core_ext/kernel/reporting.rb#L88
  # We use it only as a testing helper in a non-threaded environment
  def capture(stream)
    stream = stream.to_s
    captured_stream = Tempfile.new(stream)
    stream_io = eval("$#{stream}")
    origin_stream = stream_io.dup
    stream_io.reopen(captured_stream)

    yield

    stream_io.rewind
    return captured_stream.read
  ensure
    captured_stream.close
    captured_stream.unlink
    stream_io.reopen(origin_stream)
  end
end

RSpec.configure do |c|
  c.include OutputHelpers
end
