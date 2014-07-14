# coding: utf-8
# The main module of the tool contains configuration code and some constants
module ResponseMate
  class OutputDirError < StandardError; end
  class KeysNotFound < StandardError; end

  HTTP_METHODS = %w(GET POST PUT PATCH DELETE HEAD OPTIONS)
  DEFAULT_HEADERS = { 'User-Agent' => 'Response-Mate' }

  class << self
    attr_accessor :configuration
  end

  class Configuration
    attr_accessor :output_dir, :requests_manifest, :environment

    def initialize
      @output_dir = './output/responses/'
      @requests_manifest = './requests.yml'
      @environment = './environment.yml'
    end
  end

  def self.setup
    self.configuration ||= Configuration.new
    yield(configuration) if block_given?
  end
end
