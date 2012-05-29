# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "bcms_blog/version"

Gem::Specification.new do |s|
  s.name = %q{bcms_blog}
  s.rubyforge_project = s.name
  s.version = BcmsBlog::VERSION
  s.authors = ["BrowserMedia"]
  s.description = %q{The Blog Module for BrowserCMS}
  s.extra_rdoc_files = [
    "LICENSE.txt",
     "README.markdown"
  ]
  s.summary = "The Blog Module for BrowserCMS"
  s.email = "github@browsermedia.com"
  s.homepage = "http://www.github.com/browsermedia/bcms_blog"
  
  s.files = Dir["{app,config,db,lib}/**/*"]
  s.files += Dir["Gemfile", "LICENSE.txt", "COPYRIGHT.txt", "GPL.txt" ]
  
  s.test_files += Dir["test/**/*"]
  s.test_files -= Dir['test/dummy/**/*']
  
  s.add_dependency("browsercms", "< 3.6.0", ">= 3.5.0.rc4")
 

end

