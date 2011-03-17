# Editted directly
Gem::Specification.new do |s|
  s.name = %q{bcms_blog}
  s.version = "1.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["BrowserMedia"]
  s.date = %q{2010-05-24}
  s.description = %q{The Blog Module for BrowserCMS}
  s.email = %q{github@browsermedia.com}
  s.extra_rdoc_files = [
    "LICENSE.txt",
     "README.markdown"
  ]
  s.name = "bcms_blog"
  s.rubyforge_project = "browsercms"
  s.summary = "The Blog Module for BrowserCMS"
  s.email = "github@browsermedia.com"
  s.homepage = "http://www.github.com/browsermedia/bcms_blog"
  s.description = "The Blog Module for BrowserCMS"
  s.authors = ["BrowserMedia"]
  s.files += Dir["app/**/*"]
  s.files += Dir["doc/**/*"]
  s.files += Dir["db/migrate/[0-9]*.rb"].reject {|f| f =~ /_browsercms|_load_seed/ }
  s.files += Dir["lib/bcms_blog.rb"]
  s.files += Dir["lib/bcms_blog/*"]
  s.files += Dir["rails/init.rb"]
  # s.files = [
  #     "app/controllers/application_controller.rb",
  #      "app/controllers/cms/blog_comments_controller.rb",
  #      "app/controllers/cms/blog_posts_controller.rb",
  #      "app/controllers/cms/blogs_controller.rb",
  #      "app/helpers/application_helper.rb",
  #      "app/helpers/cms/blog_helper.rb",
  #      "app/models/blog.rb",
  #      "app/models/blog_comment.rb",
  #      "app/models/blog_group_membership.rb",
  #      "app/models/blog_post.rb",
  #      "app/portlets/blog_post_portlet.rb",
  #      "app/portlets/blog_posts_portlet.rb",
  #      "app/views/cms/blog_comments/_form.html.erb",
  #      "app/views/cms/blog_comments/render.html.erb",
  #      "app/views/cms/blog_posts/_form.html.erb",
  #      "app/views/cms/blog_posts/no_access.html.erb",
  #      "app/views/cms/blog_posts/render.html.erb",
  #      "app/views/cms/blogs/_form.html.erb",
  #      "app/views/cms/blogs/admin_only.html.erb",
  #      "app/views/cms/blogs/render.html.erb",
  #      "app/views/partials/_blog_post.html.erb",
  #      "app/views/partials/_blog_post.html.haml",
  #      "app/views/portlets/blog_post/_form.html.erb",
  #      "app/views/portlets/blog_post/render.html.erb",
  #      "app/views/portlets/blog_posts/_form.html.erb",
  #      "app/views/portlets/blog_posts/render.html.haml",
  #      "db/migrate/20090415000000_create_blogs.rb",
  #      "db/migrate/20090415000001_create_blog_posts.rb",
  #      "db/migrate/20090415000002_create_blog_comments.rb",
  #      "db/migrate/20090415000003_add_attachment_to_blog_posts.rb",
  #      "db/migrate/20100521042244_add_moderate_comments_to_blog.rb",
  #      "doc/README_FOR_APP",
  #      "doc/migrate_to_20100427.rb",
  #      "doc/release_notes.txt",
  #      "lib/bcms_blog.rb",
  #      "lib/bcms_blog/routes.rb",
  #      "rails/init.rb"
  #   ]
  s.homepage = %q{http://browsercms.org}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{browsercms}
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{The Blog Module for BrowserCMS}
  s.add_dependency('browsercms', '3.3.0')
end
