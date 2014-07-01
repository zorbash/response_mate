# coding: utf-8

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'response_mate'
require 'fakeweb'
#require 'coveralls'

#Coveralls.wear!

Dir["./spec/support/**/*.rb"].sort.each { |f| require f}

RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true
  #c.filter_run :focus
end
