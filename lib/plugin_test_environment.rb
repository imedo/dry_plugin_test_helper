class PluginTestEnvironment
  
  cattr_accessor :plugin_path
  
  # initializes the test environment
  #
  #
  def self.initialize_environment(plugin_dir, options = {:use_standard_migration => true})
    self.plugin_path = "#{plugin_dir}/.."
    require File.dirname(__FILE__) + '/../rails_root/config/environment.rb'
    ActiveRecord::Migrator.migrate("#{RAILS_ROOT}/db/migrate") if options[:use_standard_migration]
    plugin_migration
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
      require custom_migration
      Migration.up
    end
  end 
 
 class Migration < ActiveRecord::Migration
    def self.setup(&block)
      self.class.send(:define_method, :up, &block)
    end
  end
 
end