# coding: utf-8

module ResponseMate
  module Commands
    class ResponseMate::Commands::Export < Base

      def initialize(args, options)
        super(args, options)
        @type = args.first || 'requests'

        @options[:manifest] = ResponseMate::Manifest.new(options[:requests_manifest])
      end

      def run
        output = ResponseMate::Exporter.new(options).export
        if options[:pretty]
          puts JSON.pretty_generate(output)
        else
          puts output.to_json
        end
      end
    end
  end
end
