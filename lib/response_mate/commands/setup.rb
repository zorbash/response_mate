# Handles the invocation of the setup command
class ResponseMate::Commands::Setup < ResponseMate::Commands::Base
  attr_accessor :output_dir

  def initialize(args, options)
    super(args, options)
    @options = options.dup

    @output_dir = args.present? ? args.first : ResponseMate.configuration.output_dir
  end

  # Run the command based on args, options provided
  def run
    FileUtils.mkdir_p(output_dir)
    puts "[Setup] Initialized empty directory #{output_dir}"
  end
end
