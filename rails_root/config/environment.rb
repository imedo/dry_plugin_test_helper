# Specifies gem version of Rails to use when vendor/rails is not present
#RAILS_GEM_VERSION = '1.1.6'
#RAILS_GEM_VERSION = '2.0.2' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Dependencies.log_activity = false

# Load the testing framework
silence_warnings { RAILS_ENV = ENV['RAILS_ENV'] }

