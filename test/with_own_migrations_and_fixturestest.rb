require File.dirname(__FILE__) + '/../lib/dry_plugin_test_helper'

PluginTestEnvironment.remove_environment_for_rails_version(PluginTestEnvironment.latest_rails_version)
PluginTestEnvironment.initialize_environment(File.dirname(__FILE__) + "/fake_plugin_with_fixtures/test/", :use_standard_migration => false)

class WithOwnMigrationsAndFixturesTest < Test::Unit::TestCase

  fixtures :cats

  def test_loading_of_fixtures
    assert_equal 2, Cat.count
  end
end
