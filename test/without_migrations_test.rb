require File.dirname(__FILE__) + '/../lib/dry_plugin_test_helper'

PluginTestEnvironment.remove_environment_for_rails_version(PluginTestEnvironment.latest_rails_version)
PluginTestEnvironment.initialize_environment(File.dirname(__FILE__) + "/fake_plugin/test/", :use_standard_migration => false)

class WithMigrationsTest < Test::Unit::TestCase

  def test_loading_without_standard_tables
    begin
      Article.count
    rescue ActiveRecord::StatementInvalid => e
      assert_equal "Could not find table 'articles'", e.message
    end
  end

end
