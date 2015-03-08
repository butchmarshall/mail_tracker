require "bundler/gem_tasks"
require 'rubygems'
require 'bundler/setup'

Bundler::GemHelper.install_tasks

require 'rubocop/rake_task'
RuboCop::RakeTask.new

task :default => [:spec, :rubocop]