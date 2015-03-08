# The main module of the tool contains configuration code and some constants
module ResponseMate
  class OutputDirError < Errno::ENOENT; end
  class KeysNotFound < StandardError; end

  # Methods handled by response_mate
  HTTP_METHODS = %w[GET POST PUT PATCH DELETE HEAD OPTIONS]

  # Responsible for keeping initialization configuration values
  class Configuration
    attr_accessor :output_dir, :requests_manifest, :environment

    def initialize
      @output_dir = './output/responses/'
      @requests_manifest = './requests.yml'
      @environment = './environment.yml'
    end
  end

  class << self
    attr_accessor :configuration

    # Initializer method to set configuration values
    def setup
      self.configuration ||= Configuration.new
      yield(configuration) if block_given?
    end
  end
end
