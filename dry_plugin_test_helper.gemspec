Gem::Specification.new do |s|
  s.platform  =   Gem::Platform::RUBY
  s.name      =   "dry_plugin_test_helper"
  s.version   =   "0.0.11"
  s.date      =   "2013-01-26"
  s.author    =   "Hendrik Volkmer"
  s.email     =   "hvolkmer@imedo.de"
  s.homepage  =   "http://opensource.imedo.de/"
  s.summary   =   "Providing dry standard test environment for Ruby on Rails plugins"
  s.files     =   ["lib/dry_plugin_test_helper", "lib/dry_plugin_test_helper/silent_logger.rb", "lib/dry_plugin_test_helper/version.rb", "lib/dry_plugin_test_helper.rb", "lib/plugin_test_environment.rb", "rails_root_fixtures/app", "rails_root_fixtures/app/controllers", "rails_root_fixtures/app/controllers/application.rb", "rails_root_fixtures/app/models", "rails_root_fixtures/app/models/article.rb", "rails_root_fixtures/app/models/author.rb", "rails_root_fixtures/app/models/comment.rb", "rails_root_fixtures/app/models/user.rb", "rails_root_fixtures/config", "rails_root_fixtures/config/database.yml", "rails_root_fixtures/db", "rails_root_fixtures/db/migrate", "rails_root_fixtures/db/migrate/001_create_environment.rb", "rails_root_fixtures/vendor", "rails_root_fixtures/vendor/plugins", "rails_root_fixtures/vendor/plugins/plugin_to_test", "rails_root_fixtures/vendor/plugins/plugin_to_test/init.rb", "fixtures/articles.yml"]

  s.autorequire = "active_record"
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.rdoc"]

  s.add_dependency("sqlite3-ruby", ">= 1.2.1")

  s.require_path = "lib"
end
