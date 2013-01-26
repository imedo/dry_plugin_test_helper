require 'dry_plugin_test_helper'

PluginTestEnvironment.remove_environment_for_rails_version(PluginTestEnvironment.latest_rails_version)
PluginTestEnvironment.initialize_environment(File.dirname(__FILE__) + "/fake_plugin/test/")

class WithMigrationsTest < Test::Unit::TestCase

  fixtures :articles

  def test_loading_of_fixtures
    assert_equal 2, Article.count
  end
end
