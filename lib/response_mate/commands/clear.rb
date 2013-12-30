# coding: utf-8

module ResponseMate
  module Commands
    # Handles the invocation of the clear command
    class ResponseMate::Commands::Clear < Base
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

      def run
        FileUtils.rm_rf(output_dir + '.')
        puts "All clean and shiny!"
      end
    end
  end
end
