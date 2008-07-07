require 'rubygems'
require 'active_support'
require 'active_record'

ENV['RAILS_ENV'] ||= 'sqlite3'

require File.dirname(__FILE__) + '/silent_logger'
require File.dirname(__FILE__) + '/plugin_test_environment'
