require 'cms/module_installation'

class BcmsBlog::InstallGenerator < Cms::ModuleInstallation
  add_migrations_directory_to_source_root __FILE__
  
  def copy_migrations
    rake 'bcms_blog:install:migrations'
  end
    
  def add_seed_data_to_project
    copy_file "../bcms_blog.seeds.rb", "db/bcms_blog.seeds.rb"
    append_to_file "db/seeds.rb", "\nload File.expand_path('../bcms_blog.seeds.rb', __FILE__)\n"
  end

  def add_routes
    route 'mount_bcms_blog'
  end
end
