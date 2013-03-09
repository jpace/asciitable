require 'rubygems'
require 'fileutils'
require 'rake/testtask'
require 'rubygems/package_task'
require 'rspec/core/rake_task'

task :default => :test

Rake::TestTask.new("test") do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.warning = true
  t.verbose = true
end

spec = Gem::Specification.new do |s| 
  s.name = "asciitable"
  s.version = "0.0.1"
  s.author = "Jeff Pace"
  s.email = "jeugenepace@gmail.com"
  s.homepage = "http://github.com/jpace/asciitable"
  s.platform = Gem::Platform::RUBY
  s.summary = "A crude table."
  s.description = "Displays a table using ASCII art."
  s.files = FileList["{bin,lib}/**/*"].to_a
  s.require_path = "lib"
  s.test_files = FileList["{test}/**/*test.rb"].to_a
  s.has_rdoc = true
  s.extra_rdoc_files = [ "README.md" ]

  s.add_dependency "riel", ">= 1.1.16"
  s.add_dependency "rainbow", ">= 1.1.4"
  s.add_dependency "logue", ">= 0.0.1"
end
 
Gem::PackageTask.new(spec) do |pkg| 
  pkg.need_zip = true 
  pkg.need_tar_gz = true 
end 

RSpec::Core::RakeTask.new(:spec)
