# The command all other commands inherit from to DRY common functionality
class ResponseMate::Commands::Base
  attr_accessor :args, :options

  def initialize(args, options)
    @args = args
    @options = options.dup.symbolize_keys
  end
end
