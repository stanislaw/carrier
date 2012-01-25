#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "carrier"
  gem.homepage = "http://github.com/stanislaw/carrier"
  gem.license = "MIT"
  gem.summary = %Q{Raw github-like messaging system to reuse across Rails apps}
  gem.description = %Q{Raw github-like messaging system to reuse across Rails apps. Acts as Rails 3.1 mountable engine. Fast and robust.}
  gem.email = "s.pankevich@gmail.com"
  gem.authors = ["stanislaw"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new


require 'rdoc/task'

Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Carrier'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
load 'rails/tasks/engine.rake'

require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end


task :default => :test
