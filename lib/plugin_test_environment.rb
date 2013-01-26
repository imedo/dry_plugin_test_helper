require 'dry_plugin_test_helper/version'

class PluginTestEnvironment
  include DryPluginTestHelper

  class << self
    attr_accessor :plugin_path
    attr_accessor :rails_version
  end

  # initializes the test environment
  #
  #
  def self.initialize_environment(plugin_dir, options = {})
    default_options = {
      :use_standard_migration => true
    }
    options = default_options.merge(options)

    if plugin_dir.nil?
      plugin_dir ||= find_plugin_dir_by_caller
    else
      if plugin_dir.is_a?(Hash)
        options = plugin_dir
        plugin_dir = find_plugin_dir_by_caller
      end
    end

    self.plugin_path = File.join(plugin_dir, '..')
    self.rails_version = Version.new(options[:rails_version] || self.latest_rails_version)

    require rails_root_dir + '/config/boot.rb'
    require 'dry_plugin_test_helper/silent_logger'

    Rails::Initializer.run do |config|
      config.logger = SilentLogger.new
      config.log_level = :debug

      config.cache_classes = false
      config.whiny_nils = true

      config.i18n.load_path << Dir["#{plugin_path}/locales/**/*.{yml,rb}"] if self.i18n_enabled?

      yield config if block_given?
    end

    base_test_case_class.class_eval do
      cattr_accessor :rails_root
      self.rails_root = PluginTestEnvironment.plugin_path
    end

    initialize_fixtures unless options[:skip_fixtures]

    ActiveRecord::Migrator.migrate("#{RAILS_ROOT}/db/migrate") if options[:use_standard_migration]
    plugin_migration
  end

  def self.base_test_case_class
    @base_test_case_class ||= if rails_version < Version.new('2.3.0')
      Test::Unit::TestCase
    else
      require 'active_support/test_case'

      ActiveSupport::TestCase
    end
  end

  def self.rails_dir
    File.join(test_helper_base_dir, "#{rails_version}/")
  end

  def self.rails_root_dir
    target_directory = rails_dir
    init_environment unless File.exists?(target_directory)
    target_directory
  end

  def self.test_helper_base_dir
    File.join(ENV['HOME'], ".dry_plugin_test_helper")
  end

  def self.latest_rails_version
    Gem.cache.find_name(/^rails$/).map { |g| g.version.version }.last
  end

  def self.init_environment
    target_directory = rails_dir
    FileUtils.mkdir_p target_directory
    system("rails _#{rails_version}_ #{File.expand_path(target_directory)}")
    FileUtils.rm target_directory + '/app/helpers/application_helper.rb'
    FileUtils.cp_r File.dirname(__FILE__) + '/../rails_root_fixtures/app/models', target_directory + '/app'
    FileUtils.cp_r File.dirname(__FILE__) + '/../rails_root_fixtures/app/controllers', target_directory + '/app'
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

    base_test_case_class.fixture_path = PluginTestEnvironment.fixture_path
    $LOAD_PATH.unshift(base_test_case_class.fixture_path)

    base_test_case_class.class_eval do
      def create_fixtures(*table_names)
        if block_given?
          Fixtures.create_fixtures(base_test_case_class.fixture_path, table_names) { yield }
        else
          Fixtures.create_fixtures(base_test_case_class.fixture_path, table_names)
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

  def self.i18n_enabled?
    Version.new('2.2.0') < self.rails_version
  end
end
