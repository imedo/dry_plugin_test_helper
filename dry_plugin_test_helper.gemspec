Gem::Specification.new do |s| 
  s.platform  =   Gem::Platform::RUBY
  s.name      =   "dry_plugin_test_helper"
  s.version   =   "0.0.5"
  s.date      =   "2008-11-12"
  s.author    =   "Hendrik Volkmer"
  s.email     =   "hvolkmer@imedo.de"
  s.homepage  =   "http://opensource.imedo.de/"
  s.summary   =   "Providing dry standard test environment for Ruby on Rails plugins"
  s.files     =   ["lib/dry_plugin_test_helper.rb", "lib/plugin_test_environment.rb", "lib/silent_logger.rb", "rails_root/app", "rails_root/app/controllers", "rails_root/app/controllers/application.rb", "rails_root/app/models", "rails_root/app/models/article.rb", "rails_root/app/models/author.rb", "rails_root/app/models/comment.rb", "rails_root/app/models/user.rb", "rails_root/config", "rails_root/config/boot.rb", "rails_root/config/database.yml", "rails_root/config/environment.rb", "rails_root/config/environments", "rails_root/config/environments/mysql.rb", "rails_root/config/environments/postgresql.rb", "rails_root/config/environments/sqlite.rb", "rails_root/config/environments/sqlite3.rb", "rails_root/config/routes.rb", "rails_root/db", "rails_root/db/migrate", "rails_root/db/migrate/001_create_environment.rb", "rails_root/script", "rails_root/script/console", "rails_root/vendor", "rails_root/vendor/plugins", "rails_root/vendor/plugins/plugin_to_test", "rails_root/vendor/plugins/plugin_to_test/init.rb", "fixtures/articles.yml"]

  s.autorequire = "active_record"
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.rdoc"]
  
  s.add_dependency("activerecord", ">= 1.15.3")
  s.add_dependency("sqlite3-ruby", ">= 1.2.1")
  
  s.require_path = "lib"
end
