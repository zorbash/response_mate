module ResponseMate
  module Commands
    class ResponseMate::Commands::List < Base
      attr_accessor :type

      def initialize(args, options)
        super(args, options)
        @type = args.first || 'requests'

        @options[:manifest] = ResponseMate::Manifest.new(options[:requests_manifest])
      end

      def run
        if type == 'requests'
          choices = options[:manifest].requests.map { |r| r.key.to_sym }
        elsif type == 'recordings'
          choices = Dir.glob('output/responses/*.yml').map do |f|
            File.basename(f).gsub(/\.yml/, '').to_sym
          end
        end

        puts choices.join "\n"
        puts "\n\n"
        action = choose { |menu|
          menu.prompt = 'Want to perform any of the actions above?'
          menu.choices(:record, :inspect, :no)
        }

        unless action == :no
          key = choose { |menu|
            menu.prompt = 'Which one?'
            menu.choices(*choices)
          }.to_s
        end

        if key
          case action
          when :record
            ResponseMate::Recorder.new({ manifest: options[:manifest], keys: [key] }).
              record
          when :inspect
            ResponseMate::Inspector.new(manifest: options[:manifest]).inspect_key(key)
          end
        end
      end
    end
  end
end
