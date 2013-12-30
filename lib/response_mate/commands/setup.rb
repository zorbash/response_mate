module ResponseMate
  module Commands
    # Handles the invocation of the setup command
    class ResponseMate::Commands::Setup < Base
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
        FileUtils.mkdir_p(output_dir)
        puts "[Setup] Initialized empty directory #{output_dir}"
      end
    end
  end
end
