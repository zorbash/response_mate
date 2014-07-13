# coding: utf-8
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

require 'response_mate/commands/base'

# Load all commands
Dir.glob(File.join(File.expand_path('..', __FILE__),
  'response_mate/commands/*')).each(&method(:require))

# Load all helpers
Dir.glob(File.join(File.expand_path('..', __FILE__), 'response_mate/helpers/*')).each(&method(:require))

require 'response_mate/manifest_parser'
require 'response_mate/connection'
require 'response_mate/core'
require 'response_mate/request'
require 'response_mate/environment'
require 'response_mate/manifest'
require 'response_mate/tape'
require 'response_mate/recorder'
require 'response_mate/inspector'
require 'response_mate/cli'
require 'response_mate/exporter'

# Load all exporters
require 'response_mate/exporters/postman'
require 'response_mate/exporters/postman/collection'
require 'response_mate/exporters/postman/environment'

ResponseMate.setup
