require File.dirname(__FILE__) + '/../../../lib/dry_plugin_test_helper'

PluginTestEnvironment.initialize_environment(:use_standard_migration => false)

class SelfDiscoveryTest < Test::Unit::TestCase

  def test_loading_without_standard_tables_using_plugin_dir_self_discovery
    begin
      Article.count
    rescue ActiveRecord::StatementInvalid => e
      assert_equal "Could not find table 'articles'", e.message
    end
  end

end
