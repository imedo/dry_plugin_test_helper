# Specifies gem version of Rails to use when vendor/rails is not present
#RAILS_GEM_VERSION = '1.1.6'
RAILS_GEM_VERSION = '2.0.2' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')
#require 'plugin_dependencies'

Rails::Initializer.run do |config|
  config.logger = SilentLogger.new
  config.log_level = :debug

  config.cache_classes = false
  config.whiny_nils = true
  #config.breakpoint_server = true
  config.load_paths << "#{File.dirname(__FILE__)}/../../../lib/"
end

Dependencies.log_activity = false

require 'test_help'


Test::Unit::TestCase.fixture_path = PluginTestEnvironment.fixture_path
$LOAD_PATH.unshift(Test::Unit::TestCase.fixture_path)

class Test::Unit::TestCase #:nodoc:
  def create_fixtures(*table_names)
    if block_given?
      Fixtures.create_fixtures(Test::Unit::TestCase.fixture_path, table_names) { yield }
    else
      Fixtures.create_fixtures(Test::Unit::TestCase.fixture_path, table_names)
    end
  end
  
  self.use_transactional_fixtures = false
  self.use_instantiated_fixtures  = false
end

# Load the testing framework
silence_warnings { RAILS_ENV = ENV['RAILS_ENV'] }

