# coding: utf-8

module ResponseMate
  module Commands
    class ResponseMate::Commands::Inspect < Base
      attr_reader :inspector
      attr_accessor :history

      def initialize(args, options)
        super(args, options)

        @options[:manifest] = ResponseMate::Manifest.new(options[:requests_manifest])
        @inspector = ResponseMate::Inspector.new(@options)
        @history = []
      end

      def run
        if options[:interactive]
          interactive
        else
          args.each do |key|
            inspector.inspect_key(key)
          end
        end
      end

      def interactive
        loop do
          input = ask('response_mate> ')
          case input
          when 'history'
            input = choose { |menu|
              menu.prompt = 'Replay any?'
              menu.choices(*([:no] + history))
            }.to_s
          else
            history << input
          end
          inspector.inspect_interactive(input)
        end
      end
    end
  end
end
