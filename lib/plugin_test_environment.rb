class PluginTestEnvironment
  
  class << self
    attr_accessor :plugin_path
  end  
  
  # initializes the test environment
  #
  #
  def self.initialize_environment(plugin_dir, options = {:use_standard_migration => true})
    if plugin_dir.nil?
      plugin_dir ||= find_plugin_dir_by_caller
    else
      if plugin_dir.is_a?(Hash)
        options = plugin_dir
        plugin_dir = find_plugin_dir_by_caller
      end
    end
    
    self.plugin_path = File.join(plugin_dir, '..')
    require rails_root_dir(options[:rails_version]) + '/config/boot.rb'
    require File.dirname(__FILE__) + '/silent_logger'
    
    Rails::Initializer.run do |config|
      config.logger = SilentLogger.new
      config.log_level = :debug

      config.cache_classes = false
      config.whiny_nils = true

      config.load_paths << "#{File.dirname(__FILE__)}/../../../lib/"
      
      yield config if block_given?
    end
    
    require rails_root_dir(options[:rails_version]) + '/config/environment.rb'
    
    Test::Unit::TestCase.class_eval do
      cattr_accessor :rails_root
      self.rails_root = PluginTestEnvironment.plugin_path
    end
    
    initialize_fixtures unless options[:skip_fixtures]
    
    ActiveRecord::Migrator.migrate("#{RAILS_ROOT}/db/migrate") if options[:use_standard_migration]
    plugin_migration
  end
  
  def self.rails_root_dir(rails_version)
    rails_dir = File.join(test_helper_base_dir, "#{rails_version || latest_rails_version}/")
    init_environment(rails_version || latest_rails_version) unless File.exists?(rails_dir)
    rails_dir
  end
  
  def self.test_helper_base_dir
    File.join(ENV['HOME'], ".dry_plugin_test_helper")
  end
  
  def self.latest_rails_version
    Gem.cache.find_name(/^rails$/).map { |g| g.version.version }.last
  end
  
  def self.init_environment(rails_version)
    target_directory = File.join(test_helper_base_dir, rails_version)
    FileUtils.mkdir_p target_directory
    system("rails _#{rails_version}_ #{File.expand_path(target_directory)}")
    FileUtils.cp_r File.dirname(__FILE__) + '/../rails_root_fixtures/app/models', target_directory + '/app'
    FileUtils.cp_r File.dirname(__FILE__) + '/../rails_root_fixtures/db/migrate', target_directory + '/db'
    FileUtils.cp_r File.dirname(__FILE__) + '/../rails_root_fixtures/vendor/plugins/plugin_to_test', target_directory + '/vendor/plugins/'
    FileUtils.cp File.dirname(__FILE__) + '/../rails_root_fixtures/config/database.yml', target_directory + '/config/database.yml'
  end
  
  def self.remove_environment_for_rails_version(version)
    dir = File.join(test_helper_base_dir, version)
    FileUtils.rm_r(dir) if File.exists?(dir)
  end
  
  def self.initialize_engines_environment(plugin_dir, options = {:use_standard_migration => true})
    initialize_environment(plugin_dir, options.merge(:skip_fixtures => true)) do |config|
      initialize_engines
      set_app_load_paths(config)
      set_nested_plugin_load_paths(config)
      yield config if block_given?
    end

    set_app_view_path
    load_nested_plugins
    set_nested_plugin_view_paths

    initialize_fixtures unless options[:skip_fixtures]
  end
  
  def self.initialize_engines
    require "#{self.plugin_path}/vendor/plugins/engines/boot"
    Engines.use_plugin_asset_directory = false
  end
  
  def self.set_app_load_paths(config)
    Dir["#{self.plugin_path}/app/**"].each do |path|
      config.load_paths << path
    end
  end
  
  def self.set_nested_plugin_load_paths(config)
    Dir["#{self.plugin_path}/vendor/plugins/*/init.rb"].each do |plugin|
      nested_plugin_dir = File.dirname(plugin)
      Dir["#{nested_plugin_dir}/lib", "#{nested_plugin_dir}/app/**"].each do |path|
        config.load_paths << path
      end
    end
  end
  
  def self.set_app_view_path
    view_path = File.join(self.plugin_path, 'app', 'views')
    if File.exist?(view_path)
      ActionController::Base.view_paths.insert(1, view_path)
    end
  end
  
  def self.load_nested_plugins
    Dir.glob("#{self.plugin_path}/vendor/plugins/*/init.rb").each do |plugin|
      require plugin
    end
  end
  
  def self.set_nested_plugin_view_paths
    Dir.glob("#{self.plugin_path}/vendor/plugins/*/init.rb").each do |plugin|
      nested_plugin_dir = File.dirname(plugin)
      view_path = File.join(nested_plugin_dir, 'app', 'views')
      if File.exist?(view_path)
        ActionController::Base.view_paths.insert(1, view_path)
      end
    end
  end
  
  def self.initialize_fixtures
    require 'test_help'

    Test::Unit::TestCase.fixture_path = PluginTestEnvironment.fixture_path
    $LOAD_PATH.unshift(Test::Unit::TestCase.fixture_path)

    Test::Unit::TestCase.class_eval do
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
  end

  # initializes the test environment
  #
  # deprecated - use PluginTestEnvironment#initialize_environment instead
  def self.init_env(plugin_dir, use_standard_migration = true)
    puts "This method is deprecated please use PluginTestEnvironment#initialize_environment instead"
    initialize_environment(plugin_dir, :use_standard_migration => use_standard_migration)
  end
  
  def self.fixture_path
    if File.exists?(PluginTestEnvironment.plugin_path + '/test/fixtures')
      PluginTestEnvironment.plugin_path + '/test/fixtures'
    else
      File.dirname(__FILE__) + "/../fixtures/"
    end
  end
  
  def self.log_path
    PluginTestEnvironment.plugin_path + '/test/log'
  end
  
  def self.plugin_migration
    custom_migration = "#{PluginTestEnvironment.plugin_path}/test/migration.rb"
    if File.exists?(custom_migration)
      self.const_set(:Migration, Class.new(ActiveRecord::Migration))
      Migration.class_eval do
        def self.setup(&block)
          self.class.send(:define_method, :up, &block)
        end
      end
      require custom_migration
      Migration.up
    end
  end 
  
  def self.find_plugin_dir_by_caller
    # 1 = two levels up => Where the env is initialized
    File.dirname(caller[1].split(":").first)
  end
 
end