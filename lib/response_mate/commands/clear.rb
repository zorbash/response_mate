# Handles the invocation of the clear command
class ResponseMate::Commands::Clear < ResponseMate::Commands::Base
  attr_accessor :output_dir

  def initialize(args, options)
    super(args, options)
    @options = options.dup

    @output_dir = if args.present?
                    args.first
                  else
                    ResponseMate.configuration.output_dir
                  end
  end

  # Run the command based on args, options provided
  def run
    FileUtils.rm_rf(output_dir + '.')
    puts 'All clean and shiny!'
  end
end
