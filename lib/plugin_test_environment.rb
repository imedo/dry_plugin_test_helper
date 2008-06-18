class PluginTestEnvironment
  
  cattr_accessor :plugin_path
  
  def self.init_env(dir, standard_migration = true)
    self.plugin_path = "#{dir}/.."
    require File.dirname(__FILE__) + '/../rails_root/config/environment.rb'
    ActiveRecord::Migrator.migrate("#{RAILS_ROOT}/db/migrate") if standard_migration
    plugin_migration
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
    begin
      require "#{PluginTestEnvironment.plugin_path}/test/migration"
      Migration.up
    rescue LoadError
    end
  end
   
 class Migration < ActiveRecord::Migration
    def self.setup(&block)
      self.class.send(:define_method, :up, &block)
    end
  end
 
end