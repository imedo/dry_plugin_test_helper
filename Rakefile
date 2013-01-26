require 'rubygems'
require 'rake/gempackagetask'
require 'rake/testtask'
require 'rake/rdoctask'
 
spec = eval(File.read('dry_plugin_test_helper.gemspec'))
 
Rake::GemPackageTask.new(spec) do |pkg|
    pkg.need_tar = true
end

desc 'Test the gem.'
task :test do
  Dir["test/**/*_test.rb"].each do |test|
    puts `ruby -Ilib:test #{test}`
  end
end

task :default => "pkg/#{spec.name}-#{spec.version}.gem" do
  puts "generated latest version"
end

task :install => "pkg/#{spec.name}-#{spec.version}.gem" do
  sh "gem install pkg/#{spec.name}-#{spec.version}.gem"
end

desc 'Generate documentation for dry_plugin_test_helper.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'dry_plugin_test_helper'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :gemspec do
  require 'erb'
  require 'date'
  File.open('dry_plugin_test_helper.gemspec', 'w') do |file|
    file.puts ERB.new(File.read('dry_plugin_test_helper.gemspec.erb')).result
  end
end
