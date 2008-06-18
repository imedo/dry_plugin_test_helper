require 'rubygems'
Gem::manage_gems
require 'rake/gempackagetask'
require 'spec/rake/spectask'
 
spec = eval(File.read('dry_plugin_test_helper.gemspec'))
 
Rake::GemPackageTask.new(spec) do |pkg|
    pkg.need_tar = true
end

task :default => "pkg/#{spec.name}-#{spec.version}.gem" do
    puts "generated latest version"
end