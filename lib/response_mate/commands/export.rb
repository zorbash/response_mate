# coding: utf-8

module ResponseMate
  module Commands
    class ResponseMate::Commands::Export < Base

      def initialize(args, options)
        super(args, options)
        @type = args.first || 'requests'

        @options[:manifest] = ResponseMate::Manifest.new(options[:requests_manifest])
        @options[:environment] = ResponseMate::Environment.new(options[:environment])
      end

      def run
        output = ResponseMate::Exporter.new(options).export
        if options[:upload]
          url = Faraday.post 'http://getpostman.com/collections' do |req|
            req.body = output.to_json
          end
          puts JSON.parse(url.body)['link']
        else
          puts JSON.pretty_generate(output)
        end
      end
    end
  end
end
