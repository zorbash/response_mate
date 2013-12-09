# coding: utf-8
require 'thor'
require 'colored'
require 'awesome_print'
require 'active_support/all'
require 'faraday'
require 'faraday_middleware'
require 'addressable/uri'

require "response_mate/version"
require "response_mate/core"
require "response_mate/thor"
require "response_mate/oauth"
require "response_mate/recorder"

ResponseMate.setup
