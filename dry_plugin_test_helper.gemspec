require 'rake'

Gem::Specification.new do |s| 
  s.platform  =   Gem::Platform::RUBY
  s.name      =   "dry_plugin_test_helper"
  s.version   =   "0.0.3"
  s.date      =   "2008-06-18"
  s.author    =   "Hendrik Volkmer"
  s.email     =   "hvolkmer@imedo.de"
  s.homepage  =   "http://opensource.imedo.de/"
  s.summary   =   "Providing dry standard test environment for Ruby on Rails plugins"
  s.files     =    FileList["{bin,lib,rails_root,fixtures}/**/*"].to_a

  s.autorequire = "active_record"
  s.test_files = FileList["{test}/**/*test.rb"].to_a
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.rdoc"]
  
  s.add_dependency("activerecord", ">= 1.15.3")
  
  s.require_path = "lib"
end
