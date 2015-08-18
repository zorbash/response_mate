# Handles the invocation of the record command
class ResponseMate::Commands::Record < ResponseMate::Commands::Base
  # Run the command based on args, options provided
  def run
    environment = ResponseMate::Environment.new(options[:environment])
    options[:manifest] = ResponseMate::Manifest.new(options[:requests_manifest],
                                                    environment)

    recorder = ResponseMate::Recorder.new(options)

    recorder.record(options[:keys])
  end
end
