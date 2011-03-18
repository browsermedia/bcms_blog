gem_root = File.expand_path(File.join(File.dirname(__FILE__), ".."))
Cms.add_to_rails_paths gem_root
Cms.add_generator_paths gem_root, "db/migrate/[0-9]*_*.rb"
ApplicationHelper.module_eval { include Cms::BlogHelper }

config.after_initialize do
  ActiveRecord::Base.observers << BlogObserver
end
