require 'cms/module_installation'

class BcmsBlog::InstallGenerator < Cms::ModuleInstallation
  add_migrations_directory_to_source_root __FILE__

  # Add migrations to be copied, by uncommenting the following file and editing as needed.
  
  ['20090415000001_create_blog_posts.rb', '20090415000000_create_blogs.rb', '20090415000002_create_blog_comments.rb', 
    '20090415000003_add_attachment_to_blog_posts.rb', '20100521042244_add_moderate_comments_to_blog.rb'].each do |mg|
      copy_migration_file mg
    end
    
    # not sure why this is here
    # def add_helpers
    #   append_to_file ''
    # end
end
