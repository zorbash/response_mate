# coding: utf-8

module ResponseMate
  module Commands
    # Handles the invocation of the record command
    class Record < Base
      def run
        environment = ResponseMate::Environment.new(options[:environment])
        manifest = ResponseMate::Manifest.new(options[:requests_manifest], environment)

        options[:manifest] = manifest

        recorder = ResponseMate::Recorder.new(options)

        recorder.record(options[:keys])
      end
    end
  end
end
