$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'response_mate'
require 'fakefs/safe'
require 'fakefs/spec_helpers'
require 'coveralls'

Coveralls.wear!

RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true
  c.include FakeFS::SpecHelpers, fakefs: true
  c.before(:all) { silence_output }
  c.after(:all) { enable_output }
end

# Redirects stderr and stdout to /dev/null.
def silence_output
  @orig_stderr = $stderr
  @orig_stdout = $stdout

  # redirect stderr and stdout to /dev/null
  $stderr = File.new('/dev/null', 'w')
  $stdout = File.new('/dev/null', 'w')
end

# Replace stdout and stderr so anything else is output correctly.
def enable_output
  $stderr = @orig_stderr
  $stdout = @orig_stdout
  @orig_stderr = nil
  @orig_stdout = nil
end
