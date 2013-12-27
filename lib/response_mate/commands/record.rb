module ResponseMate
  module Commands
    # Handles the invocation of the record command
    class ResponseMate::Commands::Record < Base
      def initialize(args, options)
        super(args, options)
        @options = options.dup
      end

      def run
        environment = ResponseMate::Environment.new(options[:environment])

        manifest = ResponseMate::Manifest.
          new(options[:requests_manifest], environment)

        options[:manifest] = manifest
        recorder = ResponseMate::Recorder.new(options)

        recorder.record

        File.open(ResponseMate.configuration.output_dir + '.last_recording', 'w') do |f|
          f << Time.current
        end
      end
    end
  end
end
