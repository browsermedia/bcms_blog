# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "tylerrick-bcms_blog"
    gemspec.rubyforge_project = "browsercms"
    gemspec.summary = "The Blog Module for BrowserCMS"
    gemspec.email = "github@browsermedia.com"
    gemspec.homepage = "http://browsercms.org"
    gemspec.description = "The Blog Module for BrowserCMS"
    gemspec.authors = ["BrowserMedia"]
    gemspec.files = Dir["app/models/*"]
    gemspec.files += Dir["app/portlets/*"]
    gemspec.files += Dir["app/controllers/cms/*"]
    gemspec.files += Dir["app/views/cms/blog*/*"]
    gemspec.files += Dir["app/views/portlets/**/*"]
    gemspec.files += Dir["db/migrate/[0-9]*_create_blog*.rb"]
    gemspec.files += Dir["lib/bcms_blog.rb"]
    gemspec.files += Dir["lib/bcms_blog/*"]
    gemspec.files += Dir["rails/init.rb"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install jeweler"
end

# These are new tasks
begin
  require 'rake/contrib/sshpublisher'
  namespace :rubyforge do
    desc "Release gem and RDoc documentation to RubyForge"
    task :release => ["rubyforge:release:gem"]
  end
rescue LoadError
  puts "Rake SshDirPublisher is unavailable or your rubyforge environment is not configured."
end

