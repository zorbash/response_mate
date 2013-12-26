module ResponseMate
  module Commands
    class ResponseMate::Commands::Record < Base

      def initialize(args, options)
        super(args, options)

        @options[:manifest] = ResponseMate::Manifest.new(options[:requests_manifest])
      end

      def run
        ResponseMate::Recorder.new(options).record
        File.open(ResponseMate.configuration.output_dir + '.last_recording', 'w') do |f|
          f << Time.current
        end
      end
    end
  end
end
