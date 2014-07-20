require 'thor'
require 'colored'
require 'awesome_print'
require 'active_support/all'
require 'faraday'
require 'faraday_middleware'
require 'addressable/uri'
require 'highline/import'
require 'mustache'
require 'ostruct'

autoload :YAML, 'yaml'

require 'response_mate/version'
require 'response_mate/core'
require 'response_mate/commands'
require 'response_mate/exporters'

module ResponseMate
  autoload :ManifestParser, 'response_mate/manifest_parser'
  autoload :Connection,     'response_mate/connection'
  autoload :Request,        'response_mate/request'
  autoload :Environment,    'response_mate/environment'
  autoload :Manifest,       'response_mate/manifest'
  autoload :Tape,           'response_mate/tape'
  autoload :Recorder,       'response_mate/recorder'
  autoload :Inspector,      'response_mate/inspector'
  autoload :CLI,            'response_mate/cli'
  autoload :Exporter,       'response_mate/exporter'
end

ResponseMate.setup
