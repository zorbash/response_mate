#!/usr/bin/env rake
require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rspec/core/rake_task'

desc 'Run RSpec'
RSpec::Core::RakeTask.new(:test) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rspec_opts = ['--color', '--format documentation']
end

task default: :test
