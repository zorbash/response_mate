# coding: utf-8

module ResponseMate
  class Thor < ::Thor
    package_name 'response_mate'

    desc 'Perform requests and records their output', 'Records'
    method_option :base_url
    method_option :request_manifest
    def record
      ResponseMate::Recorder.new(options.symbolize_keys).record
      File.open(ResponseMate.configuration.output_dir + '.last_recording', 'w') do |f|
        f << Time.current
      end
    end

    desc 'Initializes the required directory structure', 'Initializes'
    def setup
      FileUtils.mkdir_p ResponseMate.configuration.output_dir
    end

    desc 'Deletes existing response files', 'Cleans up recordings'
    def clear
      FileUtils.rm_rf(ResponseMate.configuration.output_dir + '.')
      STDOUT.print "All clean and shiny!\n"
    end

    desc 'Lists available recordings', 'Recording listing'
    def list

    end

    desc 'Exports to one of the available formats', 'Exports'
    def export

    end
  end
end
