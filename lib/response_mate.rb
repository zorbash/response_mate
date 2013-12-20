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

require "response_mate/version"
require "response_mate/core"
require "response_mate/thor"
require "response_mate/oauth"
require "response_mate/manifest_parser"
require "response_mate/recorder"
require "response_mate/exporters/postman"
require "response_mate/exporter"

ResponseMate.setup
