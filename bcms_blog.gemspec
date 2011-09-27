Gem::Specification.new do |s|
  s.name = %q{bcms_blog}
  s.rubyforge_project = "bcms_blog"
  s.version = "1.2.1"
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version
  s.authors = ["BrowserMedia"]
  s.date = %q{2010-07-11}
  s.description = %q{The Blog Module for BrowserCMS}
  s.extra_rdoc_files = [
    "LICENSE.txt",
     "README.markdown"
  ]
  s.summary = "The Blog Module for BrowserCMS"
  s.email = "github@browsermedia.com"
  s.homepage = "http://www.github.com/browsermedia/bcms_blog"
  s.files = Dir["app/**/*"]
  s.files += Dir["doc/**/*"]
  s.files += Dir["db/migrate/[0-9]*.rb"].reject {|f| f =~ /_browsercms|_load_seed/ }
  s.files += Dir["lib/**/*"]
  s.files -= Dir["lib/tasks/build_gem.rake"]
  s.add_dependency('browsercms', '>=3.3.0')

end

