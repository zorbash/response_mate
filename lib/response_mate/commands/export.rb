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
        unless options[:format].present?
          @options[:format] = choose { |menu|
            menu.prompt = 'Please pick one of the available formats'
            menu.choice(:postman)
          }.to_s
        end

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
